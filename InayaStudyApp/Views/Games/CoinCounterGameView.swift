import SwiftUI

struct CoinCounterGameView: View {
    let topic: Topic

    @EnvironmentObject private var profileStore: UserProfileStore

    private let totalRounds = 5
    private var coinTopic: Topic {
        TopicRegistry.all.first { $0.id == "money-coins" } ?? topic
    }

    @State private var round = 1
    @State private var score = 0
    @State private var problem: Problem
    @State private var userInput = ""
    @State private var showingFeedback = false
    @State private var lastWasCorrect = false
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Count every coin!"
    @State private var showComplete = false

    private var accent: Color { TopicAccent(topic: topic).color }

    init(topic: Topic) {
        self.topic = topic
        let coinTopic = TopicRegistry.all.first { $0.id == "money-coins" } ?? topic
        _problem = State(initialValue: ProblemGenerator.generate(topic: coinTopic, difficulty: .easy))
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
                    title: "Coin Counter",
                    topic: topic,
                    round: round,
                    totalRounds: totalRounds,
                    score: score,
                    sparkyMood: sparkyMood,
                    sparkySpeech: sparkySpeech
                ) {
                    VStack(spacing: 16) {
                        VStack(spacing: 16) {
                            Text("How much money is shown?")
                                .font(AppTypography.question)
                            if let visual = problem.visual {
                                ProblemVisualView(visual: visual)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        if showingFeedback {
                            feedbackCard(problem)
                        } else {
                            AdventureNumpadView(text: $userInput, accent: accent) {
                                submit(answer: userInput, problem: problem)
                            }
                        }
                    }
                }
                .navigationTitle("Coin Counter")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
            }
        }
    }

    private func feedbackCard(_ problem: Problem) -> some View {
        VStack(spacing: 8) {
            Label(lastWasCorrect ? "Cha-ching!" : "Let's count again", systemImage: lastWasCorrect ? "dollarsign.circle.fill" : "hand.point.up.left.fill")
                .font(AppTypography.cardTitle)
                .foregroundStyle(lastWasCorrect ? AppTheme.success : accent)
            if !lastWasCorrect {
                Text("Total: \(problem.correctAnswer)")
                    .font(AppTypography.bodyEmphasis)
            }
            Button("Next coin pile") { advance() }
                .font(AppTypography.sectionTitle)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .buttonStyle(.plain)
                .padding(.top, 8)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(lastWasCorrect ? AppTheme.success.opacity(0.12) : accent.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func submit(answer: String, problem: Problem) {
        guard !showingFeedback else { return }
        lastWasCorrect = ProblemGenerator.isAnswerValid(problem, userAnswer: answer)
        if lastWasCorrect {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "You counted it!"
            SoundEffects.playCorrect()
            SpeechManager.shared.speakPraise(name: profileStore.studentName, subject: .math)
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "Add each coin slowly."
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
        sparkySpeech = "Count every coin!"
        sparkyMood = .thinking
        loadRound()
    }

    private func loadRound() {
        problem = ProblemGenerator.generate(topic: coinTopic, difficulty: .easy)
    }

    private func restart() {
        round = 1
        score = 0
        userInput = ""
        showingFeedback = false
        showComplete = false
        sparkyMood = .thinking
        sparkySpeech = "Count every coin!"
        loadRound()
    }
}
