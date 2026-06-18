import SwiftUI

struct ShadowMatchGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 8
    private let accent = AppTheme.color(hex: "34495E")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var shadow = GameContent.ShadowRound(silhouette: "", prompt: "", correct: "", choices: [])
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Match the shadow!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .shadowMatch,
            grade: grade,
            subject: subject,
            title: "Shadow Match",
            totalRounds: totalRounds,
            round: $round,
            score: $score,
            showComplete: $showComplete,
            startedAt: startedAt,
            sparkyMood: sparkyMood,
            sparkySpeech: sparkySpeech,
            accent: accent
        ) {
            VStack(spacing: 20) {
                Text(shadow.prompt)
                    .font(AppTypography.quizMeta)
                    .multilineTextAlignment(.center)

                Text(shadow.silhouette)
                    .font(.system(size: 96))
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                GameChoiceGrid(choices: shadow.choices, accent: accent, layout: .fill) { pick in
                    answer(pick)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func loadRound() {
        shadow = GameContent.shadowRound(grade: grade, round: round)
    }

    private func answer(_ pick: String) {
        if pick == shadow.correct {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Sharp eyes!"
            SoundEffects.playCorrect()
            Haptics.success()
            advance()
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "Look at the shape again."
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
