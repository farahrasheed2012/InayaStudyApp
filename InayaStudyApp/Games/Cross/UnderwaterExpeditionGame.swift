import SwiftUI

struct UnderwaterExpeditionGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 9
    private let accent = AppTheme.color(hex: "0984E3")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var zone = GameContent.UnderwaterZone.surface
    @State private var question = ("", [String](), "")
    @State private var treasures = Set<GameContent.UnderwaterZone>()
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Dive through the zones!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .underwaterExpedition,
            grade: grade,
            subject: subject,
            title: "Underwater Expedition",
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
                    ForEach(GameContent.UnderwaterZone.allCases, id: \.self) { z in
                        VStack(spacing: 4) {
                            Text(z.emoji)
                                .font(.title2)
                            Text(z.title)
                                .font(AppTypography.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            if treasures.contains(z) {
                                Text("✅")
                                    .font(.caption2)
                            }
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(zone == z ? accent.opacity(0.3) : AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Text("\(zone.creature) Submarine — \(zone.title)")
                    .font(AppTypography.quizMeta)

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
        let zones = GameContent.UnderwaterZone.allCases
        zone = zones[(round - 1) % zones.count]
        question = GameContent.underwaterQuestion(grade: grade, zone: zone, round: round)
    }

    private func answer(_ pick: String) {
        if pick == question.2 {
            score += 1
            treasures.insert(zone)
            sparkyMood = .celebrating
            sparkySpeech = "Treasure found in \(zone.title)!"
            SoundEffects.playCorrect()
            Haptics.success()
            advance()
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "The submarine bounces back — try again!"
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
