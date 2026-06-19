import SwiftUI

struct AdventureMapView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @EnvironmentObject private var profileStore: UserProfileStore
    @ObservedObject private var settings = SettingsStore.shared
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var subject: Subject = .math
    @State private var grade: GradeLevel = .second
    @State private var slideDirection: CGFloat = 0

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
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    header
                    mapContent
                        .padding(.bottom, 40)
                }
                .contentColumn()
            }
            .onAppear { scrollToCurrent(proxy: proxy) }
            .onChange(of: subject) { _ in scrollToCurrent(proxy: proxy) }
            .onChange(of: grade) { _ in scrollToCurrent(proxy: proxy) }
        }
        .background(mapBackground.ignoresSafeArea())
        .navigationTitle(profileStore.greeting())
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                let streak = progressStore.streak()
                StreakRowView(
                    currentStreak: streak.current,
                    lastPracticed: progressStore.lastPracticedDate()
                )

                CharacterView(
                    mood: sparkyMood,
                    size: 52,
                    showSpeechBubble: false,
                    onTap: {
                        SoundEffects.playSparkyBleep()
                        Haptics.tap()
                    }
                )

                Button {
                    settings.voiceGuidanceEnabled.toggle()
                    if !settings.voiceGuidanceEnabled {
                        SpeechManager.shared.stop()
                    } else {
                        SpeechManager.shared.previewVoice()
                    }
                    Haptics.tap()
                } label: {
                    Image(systemName: settings.voiceGuidanceEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .font(.title3)
                        .foregroundStyle(settings.voiceGuidanceEnabled ? Color.accentColor : .secondary)
                        .frame(width: 44, height: 44)
                        .background(AppTheme.card.opacity(0.9))
                        .clipShape(Circle())
                }
                .accessibilityLabel(settings.voiceGuidanceEnabled ? "Mute Sparky voice" : "Turn on Sparky voice")
            }

            HStack(spacing: 10) {
                subjectPill(.math, label: "Math 🔢")
                subjectPill(.science, label: "Science 🔬")
            }

            if subject == .math || subject == .science {
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
                if value == .science && grade == .third {
                    // science 3rd grade supported
                } else if value == .science {
                    grade = .second
                }
            }
        } label: {
            Text(label)
                .font(AppTypography.label)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(subject == value ? Color.accentColor : AppTheme.card)
                .foregroundStyle(subject == value ? .white : .primary)
                .clipShape(Capsule())
        }
        .appTappableStyle()
    }

    private func gradePill(_ value: GradeLevel) -> some View {
        Button {
            withAnimation(.spring()) { grade = value }
        } label: {
            Text(value.rawValue)
                .font(AppTypography.label)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(grade == value ? Color.blue.opacity(0.2) : AppTheme.card)
                .clipShape(Capsule())
        }
        .appTappableStyle()
    }

    private var mapContent: some View {
        VStack(spacing: 20) {
            startEndNode(title: route.startTitle, emoji: route.startEmoji)
                .id("start")

            ForEach(Array(topicOnlyStops.enumerated()), id: \.element.id) { index, stop in
                if case .topic(let topic) = stop.kind {
                    let status = MapProgressHelper.status(
                        for: stop,
                        at: index,
                        allStops: stops,
                        progressStore: progressStore
                    )
                    let showWorld = stop.worldTitle != nil &&
                        (index == 0 || topicOnlyStops[index - 1].worldTitle != stop.worldTitle)

                    stopCard(
                        topic: topic,
                        status: status,
                        worldTitle: showWorld ? stop.worldTitle : nil,
                        worldEmoji: showWorld ? stop.worldEmoji : nil,
                        alignTrailing: index.isMultiple(of: 2)
                    )
                    .id(stop.id)
                }
            }

            startEndNode(title: route.endTitle, emoji: route.endEmoji)
                .id("end")
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }

    private func stopCard(
        topic: Topic,
        status: MapStopStatus,
        worldTitle: String?,
        worldEmoji: String?,
        alignTrailing: Bool
    ) -> some View {
        let color = TopicAccent(topic: topic).color
        let unlocked = status != .locked
        let content = stopCardContent(
            topic: topic,
            status: status,
            worldTitle: worldTitle,
            worldEmoji: worldEmoji,
            color: color,
            unlocked: unlocked
        )

        return Group {
            if unlocked {
                NavigationLink {
                    TopicActivityHubView(topic: topic)
                } label: {
                    content
                }
                .appTappableStyle()
            } else {
                content
            }
        }
        .frame(maxWidth: horizontalSizeClass == .regular ? 520 : .infinity)
        .frame(maxWidth: .infinity, alignment: alignTrailing ? .trailing : .leading)
        .accessibilityLabel("\(topic.name), \(statusLabel(status))")
        .accessibilityHint(unlocked ? "Opens study and practice" : "Complete the previous stop first")
    }

    private func stopCardContent(
        topic: Topic,
        status: MapStopStatus,
        worldTitle: String?,
        worldEmoji: String?,
        color: Color,
        unlocked: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let worldTitle, let worldEmoji {
                HStack(spacing: 8) {
                    Text(worldEmoji)
                        .font(.title2)
                    Text(worldTitle)
                        .font(AppTypography.sectionTitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(color.opacity(0.2))
            }

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(unlocked ? color : Color.gray.opacity(0.35))
                        .frame(width: 56, height: 56)
                    Image(systemName: topic.icon)
                        .font(.title2)
                        .foregroundStyle(unlocked ? .white : .secondary)
                    if status == .locked {
                        Image(systemName: "lock.fill")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .padding(5)
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                            .offset(x: 18, y: 18)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.name)
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(unlocked ? .primary : .secondary)
                        .multilineTextAlignment(.leading)
                    Text(statusLabel(status))
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                if unlocked {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                        .foregroundStyle(color)
                }

                if status == .completed {
                    Image(systemName: "star.fill")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                }
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    status == .current ? color : Color.secondary.opacity(0.2),
                    lineWidth: status == .current ? 3 : 1
                )
        )
        .shadow(color: unlocked ? color.opacity(0.15) : .clear, radius: 8, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: 22))
    }

    private func statusLabel(_ status: MapStopStatus) -> String {
        switch status {
        case .locked: return "Locked — finish the stop before this one"
        case .current: return "Ready to play!"
        case .completed: return "Completed — tap to practice again"
        }
    }

    private func startEndNode(title: String, emoji: String) -> some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 48))
            Text(title)
                .font(AppTypography.sectionTitle)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 12)
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
            .allowsHitTesting(false)
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
}
