import SwiftUI

struct AdventureMapView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @EnvironmentObject private var profileStore: UserProfileStore

    @State private var subject: Subject = .math
    @State private var grade: GradeLevel = .second
    @State private var slideDirection: CGFloat = 0
    @State private var sparkyProgress: CGFloat = 0
    @State private var pulse = false

    private var route: AdventureMapRoute {
        AdventureMapLayout.route(subject: subject, grade: grade)
    }

    private var stops: [MapStopItem] {
        MapProgressHelper.stops(subject: subject, grade: grade)
    }

    private var topicOnlyStops: [MapStopItem] {
        stops.filter {
            if case .topic = $0.kind { return true }
            return false
        }
    }

    private var sparkyMood: SparkyMood {
        if MapProgressHelper.sparkyShouldSleep(progressStore: progressStore) {
            return .sleeping
        }
        return .idle
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        header
                        mapContent
                            .padding(.bottom, 40)
                    }
                    .frame(maxWidth: 430)
                    .frame(maxWidth: .infinity)
                }
                .onAppear {
                    scrollToCurrent(proxy: proxy)
                    animateSparkyWalk()
                }
                .onChange(of: subject) { _ in
                    scrollToCurrent(proxy: proxy)
                    animateSparkyWalk()
                }
                .onChange(of: grade) { _ in
                    scrollToCurrent(proxy: proxy)
                    animateSparkyWalk()
                }
            }

            CharacterView(mood: sparkyMood, size: 64, onTap: {
                SoundEffects.playSparkyBleep()
                Haptics.tap()
            })
            .padding(.trailing, 12)
            .padding(.top, 8)
        }
        .background(mapBackground.ignoresSafeArea())
        .navigationTitle(profileStore.greeting())
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 12) {
            let streak = progressStore.streak()
            StreakRowView(
                currentStreak: streak.current,
                lastPracticed: progressStore.snapshot.streak.lastPracticedDate
            )

            HStack(spacing: 10) {
                subjectPill(.math, label: "Math 🔢")
                subjectPill(.science, label: "Science 🔬")
            }

            if subject == .math {
                HStack(spacing: 10) {
                    gradePill(.second)
                    gradePill(.third)
                }
            }
        }
        .padding()
    }

    private func subjectPill(_ value: Subject, label: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                slideDirection = value == .science ? 1 : -1
                subject = value
                if value == .science { grade = .second }
            }
        } label: {
            Text(label)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(subject == value ? Color.accentColor : AppTheme.card)
                .foregroundStyle(subject == value ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func gradePill(_ value: GradeLevel) -> some View {
        Button {
            withAnimation(.spring()) { grade = value }
        } label: {
            Text(value.rawValue)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(grade == value ? Color.blue.opacity(0.2) : AppTheme.card)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var mapContent: some View {
        ZStack(alignment: .top) {
            mapPath
                .stroke(Color.brown.opacity(0.35), style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [2, 8]))

            VStack(spacing: 36) {
                startEndNode(
                    title: route.startTitle,
                    emoji: route.startEmoji,
                    isEnd: false
                )
                .id("start")

                ForEach(Array(topicOnlyStops.enumerated()), id: \.element.id) { index, stop in
                    if let worldTitle = stop.worldTitle, let emoji = stop.worldEmoji,
                       index == 0 || topicOnlyStops[index - 1].worldTitle != worldTitle {
                        worldLabel(title: worldTitle, emoji: emoji)
                    }

                    stopNode(stop: stop, index: index)
                        .id(stop.id)
                }

                startEndNode(
                    title: route.endTitle,
                    emoji: route.endEmoji,
                    isEnd: true
                )
                .id("end")
            }
            .padding(.horizontal, 24)
            .offset(x: slideDirection * 0)
            .transition(.asymmetric(
                insertion: .move(edge: slideDirection > 0 ? .trailing : .leading),
                removal: .move(edge: slideDirection > 0 ? .leading : .trailing)
            ))
        }
        .padding(.top, 8)
    }

    private var mapPath: Path {
        let offsets = stopOffsets(count: topicOnlyStops.count + 2)
        var path = Path()
        for i in 0..<offsets.count - 1 {
            let y1 = CGFloat(i) * 120 + 40
            let y2 = CGFloat(i + 1) * 120 + 40
            let x1 = offsets[i]
            let x2 = offsets[i + 1]
            path.move(to: CGPoint(x: x1, y: y1))
            path.addCurve(
                to: CGPoint(x: x2, y: y2),
                control1: CGPoint(x: x1, y: y1 + 50),
                control2: CGPoint(x: x2, y: y2 - 50)
            )
        }
        return path
    }

    private func stopOffsets(count: Int) -> [CGFloat] {
        (0..<count).map { i in
            i.isMultiple(of: 2) ? 120 : 260
        }
    }

    @ViewBuilder
    private func stopNode(stop: MapStopItem, index: Int) -> some View {
        let offset = index.isMultiple(of: 2) ? CGFloat(-60) : CGFloat(60)
        let status = MapProgressHelper.status(for: stop, at: index, allStops: stops, progressStore: progressStore)

        switch stop.kind {
        case .start, .end:
            EmptyView()
        case .topic(let topic):
            HStack {
                if offset > 0 { Spacer() }
                NavigationLink {
                    SessionSetupView(topic: topic)
                } label: {
                    mapStopButton(topic: topic, status: status)
                }
                .disabled(status == .locked)
                .buttonStyle(.plain)
                #if targetEnvironment(macCatalyst)
                .onHover { hovering in
                    if hovering && status != .locked {
                        // hover scale handled in button
                    }
                }
                #endif
                if offset < 0 { Spacer() }
            }
            .offset(x: offset * sparkyProgress)
        }
    }

    @ViewBuilder
    private func mapStopButton(topic: Topic, status: MapStopStatus) -> some View {
        let color = TopicAccent(topic: topic).color
        ZStack {
            Circle()
                .fill(status == .locked ? Color.gray.opacity(0.35) : color)
                .frame(width: 80, height: 80)
                .shadow(color: color.opacity(status == .locked ? 0 : 0.4), radius: pulse && status == .current ? 10 : 4)
                .scaleEffect(pulse && status == .current ? 1.06 : 1)
                .animation(status == .current ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: pulse)

            Image(systemName: topic.icon)
                .font(.title2)
                .foregroundStyle(status == .locked ? Color.secondary : Color.white)

            if status == .locked {
                Image(systemName: "lock.fill")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(.black.opacity(0.45))
                    .clipShape(Circle())
            }

            if status == .completed {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                            .padding(4)
                            .background(.black.opacity(0.35))
                            .clipShape(Circle())
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 80, height: 80)
            }
        }
        .onAppear {
            if status == .current { pulse = true }
        }
    }

    private func worldLabel(title: String, emoji: String) -> some View {
        HStack(spacing: 8) {
            Text(emoji)
            Text(title)
                .font(.headline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(AppTheme.card.opacity(0.9))
        .clipShape(Capsule())
    }

    private func startEndNode(title: String, emoji: String, isEnd: Bool) -> some View {
        VStack(spacing: 6) {
            Text(emoji)
                .font(.largeTitle)
            Text(title)
                .font(.subheadline.bold())
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }

    private var mapBackground: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.color(hex: route.skyTop), AppTheme.color(hex: route.skyBottom)],
                startPoint: .top,
                endPoint: .bottom
            )
            GeometryReader { geo in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geo.size.height * 0.55))
                    path.addQuadCurve(
                        to: CGPoint(x: geo.size.width, y: geo.size.height * 0.65),
                        control: CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.45)
                    )
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
                    path.addLine(to: CGPoint(x: 0, y: geo.size.height))
                    path.closeSubpath()
                }
                .fill(AppTheme.color(hex: route.hillColor).opacity(0.35))
            }
        }
    }

    private func scrollToCurrent(proxy: ScrollViewProxy) {
        let current = MapProgressHelper.currentTopicStop(
            subject: subject,
            grade: grade,
            progressStore: progressStore
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring()) {
                proxy.scrollTo(current?.id ?? "start", anchor: .center)
            }
        }
    }

    private func animateSparkyWalk() {
        sparkyProgress = 0
        withAnimation(.easeInOut(duration: 1.2)) {
            sparkyProgress = 1
        }
    }
}
