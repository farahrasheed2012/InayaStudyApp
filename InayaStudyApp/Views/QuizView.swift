import SwiftUI

struct QuizView: View {
    let topic: Topic
    let difficulty: Difficulty
    let questionCount: Int

    @EnvironmentObject private var progressStore: ProgressStore
    @EnvironmentObject private var rewardsStore: RewardsStore
    @EnvironmentObject private var profileStore: UserProfileStore

    @StateObject private var viewModel: QuizViewModel
    @State private var showStars = false
    @State private var showBadge = false
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var hintText: String?
    @State private var slideOffset: CGFloat = 0
    @State private var shakeWrong = false
    @Environment(\.dismiss) private var dismiss

    private var accent: Color { TopicAccent(topic: topic).color }

    init(topic: Topic, difficulty: Difficulty, questionCount: Int) {
        self.topic = topic
        self.difficulty = difficulty
        self.questionCount = questionCount
        _viewModel = StateObject(wrappedValue: QuizViewModel(topic: topic, difficulty: difficulty, questionCount: questionCount))
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            progressSection
                .padding(.horizontal)
                .padding(.bottom, 8)

            if let problem = viewModel.currentProblem {
                ScrollView {
                    VStack(spacing: 16) {
                        topicLabel
                        questionCard(problem: problem)
                        answerArea(problem: problem)
                    }
                    .padding()
                    .offset(x: slideOffset)
                }
            }

            hintButton
                .padding()
        }
        .frame(maxWidth: 430)
        .frame(maxWidth: .infinity)
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.currentIndex) { _ in
            sparkyMood = .thinking
            hintText = nil
            animateSlideIn()
        }
        .onChange(of: viewModel.isComplete) { complete in
            if complete {
                viewModel.finish(progressStore: progressStore)
                let earned = rewardsStore.recordIfNewMasterBadge(
                    topicId: topic.id,
                    stars: viewModel.stars,
                    accuracy: viewModel.accuracy
                )
                showBadge = earned
                if !earned { showStars = true }
            }
        }
        .navigationDestination(isPresented: $showStars) {
            StarsEarnedView(
                viewModel: viewModel,
                topic: topic,
                studentName: profileStore.studentName,
                onContinue: { dismissToMap() }
            )
        }
        .fullScreenCover(isPresented: $showBadge) {
            RewardBadgeView(topic: topic, accuracy: viewModel.accuracy) {
                showBadge = false
                showStars = true
            }
        }
        #if targetEnvironment(macCatalyst)
        .quizKeyboardShortcuts(viewModel: viewModel, onHint: showHint)
        #endif
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Label("Back", systemImage: "chevron.left")
                    .font(.headline)
            }
            Spacer()
            Text("Q \(min(viewModel.currentIndex + 1, questionCount)) of \(questionCount)")
                .font(.subheadline.bold())
            Spacer()
            CharacterView(
                mood: sparkyMood,
                size: 52,
                speechText: hintText,
                onTap: {
                    SoundEffects.playSparkyBleep()
                    Haptics.tap()
                }
            )
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var progressSection: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                    Capsule()
                        .fill(Color.yellow)
                        .frame(width: geo.size.width * viewModel.progress)
                        .animation(.easeOut(duration: 0.35), value: viewModel.progress)
                }
            }
            .frame(height: 14)
        }
    }

    private var topicLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: topic.icon)
                .foregroundStyle(accent)
            Text(topic.name)
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func questionCard(problem: Problem) -> some View {
        VStack(spacing: 16) {
            Text(problem.questionText)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .largeReadable()

            if let visual = problem.visual {
                ProblemVisualView(visual: visual)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
        .onAppear { sparkyMood = .thinking }
    }

    @ViewBuilder
    private func answerArea(problem: Problem) -> some View {
        switch problem.answerType {
        case .multipleChoice:
            let choices = problem.choices ?? []
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                    let label = ["A", "B", "C", "D"][min(index, 3)]
                    answerButton(label: label, text: choice, correctAnswer: problem.correctAnswer)
                }
            }

        case .numberEntry:
            AdventureNumpadView(text: $viewModel.userInput, accent: accent) {
                submitIfReady()
            }

        case .tapSelection:
            let options = problem.tapOptions ?? problem.choices ?? []
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    let label = ["A", "B", "C", "D"][min(index, 3)]
                    answerButton(label: label, text: option, correctAnswer: problem.correctAnswer)
                }
            }
        }
    }

    private func answerButton(label: String, text: String, correctAnswer: String) -> some View {
        let selected = viewModel.selectedAnswer == text
        let showing = viewModel.showingFeedback
        let isCorrect = text == correctAnswer
        let fill: Color = {
            guard showing else { return AppTheme.card }
            if isCorrect { return AppTheme.success.opacity(0.85) }
            if selected { return AppTheme.danger.opacity(0.85) }
            return AppTheme.card
        }()

        return Button {
            guard !viewModel.showingFeedback else { return }
            withAnimation(.spring(response: 0.2, dampingFraction: 0.55)) {
                viewModel.submitAnswer(text)
            }
            sparkyMood = viewModel.lastWasCorrect ? .excited : .encouraging
            if !viewModel.lastWasCorrect {
                withAnimation(.default.repeatCount(3, autoreverses: true)) { shakeWrong.toggle() }
            }
        } label: {
            VStack(spacing: 8) {
                Text(label)
                    .font(.caption.bold())
                    .frame(width: 28, height: 28)
                    .background(accent.opacity(showing ? 0.2 : 0.15))
                    .foregroundStyle(accent)
                    .clipShape(Circle())
                Text(text)
                    .font(.body.bold())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(showing && (isCorrect || selected) ? .white : .primary)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 88)
            .background(fill)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(accent.opacity(showing ? 0 : 0.35), lineWidth: 2)
            )
            .scaleEffect(selected && !showing ? 0.95 : 1)
            .modifier(ShakeEffect(animating: selected && showing && !isCorrect && shakeWrong))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.showingFeedback)
    }

    private var hintButton: some View {
        HStack {
            Spacer()
            Button(action: showHint) {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundStyle(.yellow)
                    .padding(12)
                    .background(AppTheme.card)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private func showHint() {
        guard let hint = viewModel.currentProblem?.hint else { return }
        sparkyMood = .thinking
        hintText = hint
        Haptics.tap()
    }

    private func submitIfReady() {
        viewModel.submitCurrentInput()
        sparkyMood = viewModel.lastWasCorrect ? .excited : .encouraging
    }

    private func animateSlideIn() {
        slideOffset = 40
        withAnimation(.easeOut(duration: 0.35)) { slideOffset = 0 }
    }

    private func dismissToMap() {
        dismiss()
    }
}

private struct ShakeEffect: GeometryEffect {
    var animating: Bool
    var amount: CGFloat = 6

    var animatableData: CGFloat {
        get { amount }
        set { amount = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: animating ? amount : 0, y: 0))
    }
}
