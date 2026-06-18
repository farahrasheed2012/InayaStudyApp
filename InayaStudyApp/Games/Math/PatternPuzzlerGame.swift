import SwiftUI

struct PatternPuzzlerGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 10
    private let accent = AppTheme.color(hex: "6C5CE7")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var pattern = GameContent.PatternRound(sequence: [], missingIndex: 0, correct: 0, choices: [])
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "What number is missing?"

    var body: some View {
        SuiteGameWrapper(
            gameID: .patternPuzzler,
            grade: grade,
            subject: subject,
            title: "Pattern Puzzler",
            totalRounds: totalRounds,
            round: $round,
            score: $score,
            showComplete: $showComplete,
            startedAt: startedAt,
            sparkyMood: sparkyMood,
            sparkySpeech: sparkySpeech,
            accent: accent
        ) {
            VStack(spacing: 24) {
                Text("Find the missing number")
                    .font(AppTypography.quizMeta)

                HStack(spacing: 12) {
                    ForEach(pattern.displaySequence.indices, id: \.self) { index in
                        Text(pattern.displaySequence[index])
                            .font(AppTypography.hero)
                            .frame(width: 56, height: 56)
                            .background(pattern.displaySequence[index] == "?" ? accent.opacity(0.25) : AppTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .frame(maxWidth: .infinity)

                GameChoiceGrid(
                    choices: pattern.choices.map(String.init),
                    accent: accent,
                    layout: .fill
                ) { pick in
                    answer(Int(pick) ?? -1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func loadRound() {
        pattern = GameContent.patternRound(grade: grade, round: round)
    }

    private func answer(_ value: Int) {
        if value == pattern.correct {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Pattern found!"
            SoundEffects.playCorrect()
            Haptics.success()
            advance()
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "Look at the steps between numbers."
            SoundEffects.playIncorrect()
            Haptics.error()
        }
    }

    private func advance() {
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        loadRound()
        sparkyMood = .thinking
    }
}
