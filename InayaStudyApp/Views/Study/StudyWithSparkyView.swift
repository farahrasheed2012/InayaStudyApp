import SwiftUI

struct StudyWithSparkyView: View {
    let topic: Topic

    @EnvironmentObject private var profileStore: UserProfileStore
    @State private var page = 0
    @State private var exampleProblems: [Problem] = []
    @State private var revealedExamples: Set<Int> = []
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var navigateToPractice = false

    private var guide: TopicGuideContent { TopicStudyGuide.guide(for: topic) }
    private var accent: Color { TopicAccent(topic: topic).color }
    private var totalPages: Int { 2 + exampleProblems.count }

    init(topic: Topic) {
        self.topic = topic
        _exampleProblems = State(initialValue: (0..<2).map { _ in
            ProblemGenerator.generate(topic: topic, difficulty: .easy)
        })
    }

    var body: some View {
        VStack(spacing: 0) {
            studyHeader

            TabView(selection: $page) {
                guidePage.tag(0)
                workedExamplePage.tag(1)
                ForEach(Array(exampleProblems.enumerated()), id: \.offset) { index, problem in
                    exampleProblemPage(problem: problem, index: index)
                        .tag(index + 2)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(.easeInOut, value: page)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            navButtons
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(AppTheme.background.shadow(color: .black.opacity(0.06), radius: 8, y: -2))
        }
        .fullWidthContent()
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(topic.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationDestination(isPresented: $navigateToPractice) {
            SessionSetupView(topic: topic)
        }
        .onAppear {
            sparkyMood = .thinking
        }
        .onChange(of: page) { _ in
            sparkyMood = page == 0 ? .thinking : .encouraging
        }
    }

    private var studyHeader: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Step \(page + 1) of \(totalPages)")
                    .font(AppTypography.label)
                    .foregroundStyle(accent)
                Text(pageTitle)
                    .font(AppTypography.sectionTitle)
            }
            Spacer()
            CharacterView(mood: sparkyMood, size: 72)
        }
        .padding(.vertical, 12)
    }

    private var pageTitle: String {
        switch page {
        case 0: return "Learn the idea"
        case 1: return "See how it works"
        default: return "Try an example"
        }
    }

    private var navButtons: some View {
        HStack(spacing: 16) {
            if page > 0 {
                Button("Back") {
                    withAnimation { page -= 1 }
                }
                .font(AppTypography.cardTitle)
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            Spacer()
            if page < totalPages - 1 {
                Button("Next →") {
                    withAnimation { page += 1 }
                }
                .font(AppTypography.cardTitle)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(accent)
            } else {
                Button("Ready to Practice! ⭐️") {
                    navigateToPractice = true
                }
                .font(AppTypography.cardTitle)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(accent)
            }
        }
    }

    private var guidePage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                sectionCard(
                    title: "Key idea",
                    icon: "lightbulb.fill",
                    tint: accent
                ) {
                    Text(guide.keyIdea)
                        .studyText()
                        .foregroundStyle(.primary)
                }

                sectionCard(
                    title: "Words to know",
                    icon: "text.book.closed.fill",
                    tint: accent
                ) {
                    FlowLayout(spacing: 12) {
                        ForEach(guide.vocabulary, id: \.self) { word in
                            Text(word)
                                .font(AppTypography.chip)
                                .foregroundStyle(accent)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(accent.opacity(0.18))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(accent.opacity(0.4), lineWidth: 2))
                        }
                    }
                }

                sectionCard(
                    title: "Sparky's tip",
                    icon: "sparkles",
                    tint: .yellow
                ) {
                    HStack(alignment: .top, spacing: 12) {
                        Text("💡")
                            .font(.largeTitle)
                        Text(guide.studyTip)
                            .studyText()
                            .foregroundStyle(.primary)
                    }
                }
            }
            .padding(.bottom, 24)
        }
    }

    private var workedExamplePage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                sectionCard(
                    title: "Worked example",
                    icon: "pencil.and.list.clipboard",
                    tint: accent
                ) {
                    Text(guide.workedExampleQuestion)
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(.primary)
                        .padding(.bottom, 12)

                    ForEach(Array(guide.workedExampleSteps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 16) {
                            Text("\(index + 1)")
                                .font(AppTypography.badge)
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(accent)
                                .clipShape(Circle())
                            Text(step)
                                .studyText()
                                .foregroundStyle(.primary)
                        }
                        .padding(.vertical, 4)
                    }

                    HStack(spacing: 12) {
                        Text("Answer:")
                            .font(AppTypography.cardTitle)
                        Text(guide.workedExampleAnswer)
                            .font(AppTypography.hero)
                            .foregroundStyle(accent)
                    }
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.bottom, 24)
        }
    }

    private func exampleProblemPage(problem: Problem, index: Int) -> some View {
        let revealed = revealedExamples.contains(index)
        return ScrollView {
            VStack(spacing: 20) {
                Text("Try this example \(index + 1)")
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(accent)

                VStack(spacing: 16) {
                    Text(problem.questionText)
                        .font(AppTypography.sectionTitle)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)

                    if let visual = problem.visual {
                        ProblemVisualView(visual: visual)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(accent.opacity(0.3), lineWidth: 2)
                )

                if revealed {
                    VStack(spacing: 12) {
                        Text("Answer: \(problem.correctAnswer)")
                            .font(AppTypography.hero)
                            .foregroundStyle(AppTheme.success)
                        Text(TopicStudyGuide.explanation(for: problem, topic: topic))
                            .studyText()
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .transition(.opacity.combined(with: .scale))
                } else {
                    Button("Show answer") {
                        withAnimation(.spring()) {
                            revealedExamples.insert(index)
                            sparkyMood = .excited
                            SoundEffects.playCorrect()
                            SpeechManager.shared.speakPraise(
                                name: profileStore.studentName,
                                subject: topic.subject
                            )
                        }
                    }
                    .font(AppTypography.cardTitle)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(accent)
                }
            }
            .padding(.bottom, 24)
        }
    }

    private func sectionCard<Content: View>(
        title: String,
        icon: String,
        tint: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(tint.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text(title)
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(.primary)
            }

            content()
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(tint.opacity(0.35), lineWidth: 2)
        )
        .shadow(color: tint.opacity(0.12), radius: 8, y: 4)
    }
}

/// Simple wrapping layout for vocabulary chips.
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var frames: [CGRect] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), frames)
    }
}
