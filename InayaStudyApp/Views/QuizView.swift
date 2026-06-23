import SwiftUI

struct QuizView: View {
    let topic: Topic
    let difficulty: Difficulty
    let questionCount: Int

    @EnvironmentObject private var progressStore: ProgressStore
    @EnvironmentObject private var rewardsStore: RewardsStore
    @EnvironmentObject private var profileStore: UserProfileStore
    @ObservedObject private var settings = SettingsStore.shared

    @StateObject private var viewModel: QuizViewModel
    @State private var showStars = false
    @State private var showBadge = false
    @State private var showReviewMisses = false
    @State private var showDifficultyNudge = false
    @State private var timerResetToken = 0
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
                        if settings.challengeModeEnabled && !viewModel.showingFeedback {
                            HStack {
                                Spacer()
                                QuizCountdownTimer(
                                    totalSeconds: settings.challengeTimerSeconds,
                                    accent: accent
                                ) {
                                    guard !viewModel.showingFeedback else { return }
                                    viewModel.submitTimeout()
                                    sparkyMood = .encouraging
                                }
                                .id(timerResetToken)
                            }
                        }
                        topicLabel
                        questionCard(problem: problem)
                        answerArea(problem: problem)
                        feedbackCard(problem: problem)
                    }
                    .padding()
                    .offset(x: slideOffset)
                }
            }

            hintButton
                .padding()
        }
        .fullWidthContent()
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.currentIndex) { _ in
            sparkyMood = .thinking
            hintText = nil
            timerResetToken += 1
            animateSlideIn()
        }
        .onChange(of: viewModel.isComplete) { complete in
            if complete {
                viewModel.finish(progressStore: progressStore)
                if viewModel.missedProblems.isEmpty {
                    proceedToResults()
                } else {
                    showReviewMisses = true
                }
            }
        }
        .navigationDestination(isPresented: $showReviewMisses) {
            ReviewMissesView(topic: topic, missed: viewModel.missedProblems) {
                showReviewMisses = false
                proceedToResults()
            }
        }
        .navigationDestination(isPresented: $showStars) {
            StarsEarnedView(
                viewModel: viewModel,
                topic: topic,
                studentName: profileStore.studentName,
                showDifficultyNudge: $showDifficultyNudge,
                onContinue: { dismissToMap() }
            )
        }
        .fullScreenCover(isPresented: $showBadge) {
            RewardBadgeView(topic: topic, accuracy: viewModel.accuracy, studentName: profileStore.studentName) {
                showBadge = false
                showStars = true
            }
        }
        .quizKeyboardShortcuts(viewModel: viewModel, onHint: showHint)
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Label("Back", systemImage: "chevron.left")
                    .font(AppTypography.quizMeta)
            }
            Spacer()
            Text("Q \(min(viewModel.currentIndex + 1, questionCount)) of \(questionCount)")
                .font(AppTypography.quizMeta)
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
            .frame(height: 18)
        }
    }

    private var topicLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: topic.icon)
                .foregroundStyle(accent)
            Text(topic.name)
                .font(AppTypography.quizMeta)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func questionCard(problem: Problem) -> some View {
        VStack(spacing: 16) {
            Text(problem.questionText)
                .questionText()

            if let visual = problem.visual {
                ProblemVisualView(visual: visual)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
        .onAppear { sparkyMood = .thinking }
    }

    @ViewBuilder
    private func feedbackCard(problem: Problem) -> some View {
        if viewModel.showingFeedback {
            VStack(spacing: 8) {
                if viewModel.lastWasCorrect {
                    Label("Great job!", systemImage: "checkmark.circle.fill")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppTheme.success)
                    Text(viewModel.encouragement)
                        .quizFeedback()
                        .foregroundStyle(.secondary)
                } else {
                    Label("Let's learn this one", systemImage: "book.fill")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(accent)
                    Text(TopicStudyGuide.explanation(for: problem, topic: topic))
                        .quizFeedback()
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(viewModel.lastWasCorrect ? AppTheme.success.opacity(0.12) : accent.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    @ViewBuilder
    private func answerArea(problem: Problem) -> some View {
        switch problem.answerType {
        case .multipleChoice:
            let choices = problem.choices ?? []
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                    let label = ["A", "B", "C", "D"][min(index, 3)]
                    answerButton(label: label, text: choice, correctAnswer: problem.correctAnswer)
                }
            }

        case .numberEntry:
            AdventureNumpadView(
                text: $viewModel.userInput,
                accent: accent,
                questionIndex: viewModel.currentIndex
            ) {
                submitIfReady()
            }

        case .tapSelection:
            let options = problem.tapOptions ?? problem.choices ?? []
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
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
            VStack(spacing: 10) {
                Text(label)
                    .font(AppTypography.sectionTitle)
                    .frame(width: 40, height: 40)
                    .background(accent.opacity(showing ? 0.2 : 0.15))
                    .foregroundStyle(accent)
                    .clipShape(Circle())
                Text(text)
                    .font(AppTypography.answer)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .minimumScaleFactor(0.85)
                    .foregroundStyle(showing && (isCorrect || selected) ? .white : .primary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 112)
            .background(fill)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(accent.opacity(showing ? 0 : 0.35), lineWidth: 2)
            )
            .scaleEffect(selected && !showing ? 0.95 : 1)
            .modifier(ShakeEffect(animating: selected && showing && !isCorrect && shakeWrong))
        }
        .appTappableStyle()
        .disabled(viewModel.showingFeedback)
    }

    private var hintButton: some View {
        HStack {
            Spacer()
            Button(action: showHint) {
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                    .foregroundStyle(.yellow)
                    .padding(16)
                    .background(AppTheme.card)
                    .clipShape(Circle())
            }
            .appTappableStyle()
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
        showStars = false
        showReviewMisses = false
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            NotificationCenter.default.post(name: .quizSessionCompletePop, object: nil)
        }
    }

    private func proceedToResults() {
        if DifficultyNudgeEvaluator.shouldNudge(
            progressStore: progressStore,
            subject: topic.subject,
            difficulty: difficulty
        ) {
            showDifficultyNudge = true
        }

        let earned = rewardsStore.recordIfNewMasterBadge(
            topicId: topic.id,
            stars: viewModel.stars,
            accuracy: viewModel.accuracy
        )
        showBadge = earned
        if !earned { showStars = true }
    }
}

extension Notification.Name {
    /// Posted after quiz results; SessionSetup pops itself, then may chain to topic hub.
    static let quizSessionCompletePop = Notification.Name("InayaStudyApp.quizSessionCompletePop")
    static let topicHubPop = Notification.Name("InayaStudyApp.topicHubPop")
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
