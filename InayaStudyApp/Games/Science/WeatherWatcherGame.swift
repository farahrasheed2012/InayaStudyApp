import SwiftUI

struct WeatherWatcherGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 10
    private let accent = AppTheme.color(hex: "3498DB")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var pack: (kind: GameContent.WeatherRoundKind, scene: String, prompt: String, choices: [String], correct: String) = (.condition, "", "", [], "")
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Watch the weather!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .weatherWatcher,
            grade: grade,
            subject: subject,
            title: "Weather Watcher",
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
                sceneView

                Text(pack.prompt)
                    .font(AppTypography.question)
                    .multilineTextAlignment(.center)

                GameChoiceGrid(choices: pack.choices, accent: accent, layout: .fill) { choice in
                    if choice == pack.correct {
                        score += 1
                        SoundEffects.playCorrect()
                        Haptics.success()
                        sparkyMood = .celebrating
                        advance()
                    } else {
                        SoundEffects.playIncorrect()
                        Haptics.error()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { loadRound() }
    }

    private var sceneView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(sceneColor.opacity(0.35))
                .frame(height: 140)
            VStack {
                Text(sceneEmoji)
                    .font(.system(size: 48))
                Text(pack.scene)
                    .font(AppTypography.label)
            }
        }
        .accessibilityLabel("Scene \(pack.scene)")
    }

    private var sceneEmoji: String {
        switch pack.scene {
        case "Arctic", "Snowy day": return "❄️"
        case "Rainforest": return "🌧️"
        case "Desert": return "☀️"
        case "Weather lab": return "🔬"
        default: return "🌤️"
        }
    }

    private var sceneColor: Color {
        switch pack.scene {
        case "Desert": return .orange
        case "Arctic", "Snowy day": return .cyan
        case "Rainforest": return .green
        default: return .blue
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

    private func loadRound() {
        pack = GameContent.weatherRound(grade: grade)
    }
}
