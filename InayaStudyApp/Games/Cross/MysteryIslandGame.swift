import SwiftUI

struct MysteryIslandGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 5
    private let accent = AppTheme.color(hex: "F39C12")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var mysteryCase = GameContent.mysteryCase(grade: .second)
    @State private var clueReveal: String?
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Solve clues to crack the case!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .mysteryIsland,
            grade: grade,
            subject: subject,
            title: "Mystery Island",
            totalRounds: totalRounds,
            round: $round,
            score: $score,
            showComplete: $showComplete,
            startedAt: startedAt,
            sparkyMood: sparkyMood,
            sparkySpeech: sparkySpeech,
            accent: accent
        ) {
            let clue = currentClue
            VStack(spacing: 16) {
                Text("🏝️ \(mysteryCase.title)")
                    .font(AppTypography.sectionTitle)

                if round == 1 {
                    Text(mysteryCase.intro)
                        .font(AppTypography.studyBody)
                        .multilineTextAlignment(.center)
                }

                Text(clue.chapter)
                    .font(AppTypography.quizMeta)
                    .foregroundStyle(accent)

                if let clueReveal {
                    Text(clueReveal)
                        .font(AppTypography.studyBody)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(12)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Text(clue.question)
                    .font(AppTypography.question)
                    .multilineTextAlignment(.center)

                GameChoiceGrid(choices: clue.choices, accent: accent, layout: .fill) { pick in
                    answer(pick, clue: clue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            mysteryCase = GameContent.mysteryCase(grade: grade)
        }
    }

    private var currentClue: (chapter: String, question: String, choices: [String], correct: String, reveal: String) {
        let clues = mysteryCase.clues
        return clues[min(round - 1, clues.count - 1)]
    }

    private func answer(_ pick: String, clue: (chapter: String, question: String, choices: [String], correct: String, reveal: String)) {
        if pick == clue.correct {
            score += 1
            clueReveal = clue.reveal
            sparkyMood = .celebrating
            sparkySpeech = round == totalRounds ? "Case closed: \(mysteryCase.culprit)!" : "Clue unlocked!"
            SoundEffects.playCorrect()
            Haptics.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { advance() }
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "Keep investigating!"
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
        clueReveal = nil
        sparkyMood = .thinking
    }
}
