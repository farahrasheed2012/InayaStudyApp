import SwiftUI

struct TimeTravelerGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 9
    private let accent = AppTheme.color(hex: "6C5CE7")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var era = GameContent.TimeEra.egypt
    @State private var question = ("", [String](), "")
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Travel through time!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .timeTraveler,
            grade: grade,
            subject: subject,
            title: "Time Traveler",
            totalRounds: totalRounds,
            round: $round,
            score: $score,
            showComplete: $showComplete,
            startedAt: startedAt,
            sparkyMood: sparkyMood,
            sparkySpeech: sparkySpeech,
            accent: accent
        ) {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    ForEach(GameContent.TimeEra.allCases, id: \.self) { e in
                        VStack(spacing: 4) {
                            Text(e.emoji)
                            Text(e.title)
                                .font(AppTypography.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(era == e ? accent.opacity(0.3) : AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }

                Text("⏳ \(era.title)")
                    .font(AppTypography.sectionTitle)

                Text(question.0)
                    .font(AppTypography.question)
                    .multilineTextAlignment(.center)

                GameChoiceGrid(choices: question.1, accent: accent, layout: .fill) { pick in
                    answer(pick)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func loadRound() {
        let eras = GameContent.TimeEra.allCases
        era = eras[(round - 1) % eras.count]
        question = GameContent.timeTravelerQuestion(grade: grade, era: era, round: round)
    }

    private func answer(_ pick: String) {
        if pick == question.2 {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Time portal opens!"
            SoundEffects.playCorrect()
            Haptics.success()
            advance()
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "The portal flickers — try again!"
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
