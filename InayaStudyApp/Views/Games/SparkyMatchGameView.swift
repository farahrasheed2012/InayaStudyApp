import SwiftUI

struct SparkyMatchGameView: View {
    let topic: Topic

    @EnvironmentObject private var profileStore: UserProfileStore

    private let totalRounds = 5

    @State private var round = 1
    @State private var score = 0
    @State private var problem: Problem
    @State private var userInput = ""
    @State private var showingFeedback = false
    @State private var lastWasCorrect = false
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String?
    @State private var showComplete = false

    private var accent: Color { TopicAccent(topic: topic).color }

    init(topic: Topic) {
        self.topic = topic
        _problem = State(initialValue: TopicGameProblemFactory.sparkyMatchProblem(topic: topic))
    }

    var body: some View {
        Group {
            if showComplete {
                GameCompleteView(
                    topic: topic,
                    score: score,
                    totalRounds: totalRounds,
                    studentName: profileStore.studentName,
                    onPlayAgain: restart
                )
            } else {
                GameShellView(
                    title: "Sparky Match",
                    topic: topic,
                    round: round,
                    totalRounds: totalRounds,
                    score: score,
                    sparkyMood: sparkyMood,
                    sparkySpeech: sparkySpeech
                ) {
                    VStack(spacing: 16) {
                        problemCard(problem)
                        if showingFeedback {
                            feedbackCard(problem)
                        } else {
                            answerArea(problem)
                        }
                    }
                }
                .navigationTitle("Sparky Match")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
            }
        }
    }

    private func problemCard(_ problem: Problem) -> some View {
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
    }

    @ViewBuilder
    private func answerArea(_ problem: Problem) -> some View {
        switch problem.answerType {
        case .multipleChoice, .tapSelection:
            let options = problem.choices ?? problem.tapOptions ?? []
            if options.isEmpty {
                Text("Loading a new question…")
                    .font(AppTypography.bodyEmphasis)
                    .foregroundStyle(.secondary)
                    .onAppear { loadRound() }
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        choiceButton(label: ["A", "B", "C", "D"][min(index, 3)], text: option, correct: problem.correctAnswer, problem: problem)
                    }
                }
            }
        case .numberEntry:
            AdventureNumpadView(text: $userInput, accent: accent) {
                submit(userInput, correct: problem.correctAnswer, problem: problem)
            }
        }
    }

    private func choiceButton(label: String, text: String, correct: String, problem: Problem) -> some View {
        Button {
            submit(text, correct: correct, problem: problem)
        } label: {
            VStack(spacing: 6) {
                Text(label)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
                Text(text)
                    .font(AppTypography.answer)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, minHeight: 72)
            .padding(8)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(accent.opacity(0.3), lineWidth: 2))
        }
        .appTappableStyle()
        .disabled(showingFeedback)
    }

    private func feedbackCard(_ problem: Problem) -> some View {
        VStack(spacing: 8) {
            Label(lastWasCorrect ? "Yes!" : "Good try!", systemImage: lastWasCorrect ? "checkmark.circle.fill" : "lightbulb.fill")
                .font(AppTypography.cardTitle)
                .foregroundStyle(lastWasCorrect ? AppTheme.success : accent)
            if !lastWasCorrect {
                Text("Answer: \(problem.correctAnswer)")
                    .font(AppTypography.bodyEmphasis)
            }
            if let fact = problem.funFact, lastWasCorrect {
                Text(fact)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            Button("Next") { advance() }
                .font(AppTypography.sectionTitle)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .appTappableStyle()
                .padding(.top, 8)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(lastWasCorrect ? AppTheme.success.opacity(0.12) : accent.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func submit(_ answer: String, correct: String, problem: Problem) {
        guard !showingFeedback else { return }
        let ok = ProblemGenerator.isAnswerValid(problem, userAnswer: answer)
        lastWasCorrect = ok
        if ok {
            score += 1
            sparkyMood = .excited
            sparkySpeech = Encouragement.random(for: topic.subject, name: profileStore.studentName)
            SoundEffects.playCorrect()
            SpeechManager.shared.speakPraise(name: profileStore.studentName, subject: topic.subject)
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "The answer was \(correct)"
            SoundEffects.playIncorrect()
        }
        Haptics.tap()
        withAnimation { showingFeedback = true }
    }

    private func advance() {
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        userInput = ""
        showingFeedback = false
        sparkySpeech = nil
        sparkyMood = .thinking
        loadRound()
    }

    private func loadRound() {
        problem = TopicGameProblemFactory.sparkyMatchProblem(topic: topic)
    }

    private func restart() {
        round = 1
        score = 0
        userInput = ""
        showingFeedback = false
        showComplete = false
        sparkyMood = .thinking
        sparkySpeech = nil
        loadRound()
    }
}
