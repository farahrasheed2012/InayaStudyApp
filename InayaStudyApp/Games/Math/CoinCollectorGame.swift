import SwiftUI

struct CoinCollectorGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 10
    private let accent = AppTheme.color(hex: "F1C40F")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var targetCents = 0
    @State private var purseCents = 0
    @State private var beltCoins: [Int] = []
    @State private var shake = false
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Tap coins to match the target!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .coinCollector,
            grade: grade,
            subject: subject,
            title: "Coin Collector",
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
                Text("Make \(moneyString(targetCents))")
                    .font(AppTypography.hero)

                HStack {
                    Image(systemName: "bag.fill")
                        .font(.largeTitle)
                        .foregroundStyle(accent)
                    Text(moneyString(purseCents))
                        .font(AppTypography.question)
                }
                .padding()
                .background(AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .modifier(ShakeEffect(animating: shake))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(beltCoins.indices, id: \.self) { index in
                            coinButton(cents: beltCoins[index], index: index)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Button("Done") { submit() }
                    .font(AppTypography.sectionTitle)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .appTappableStyle()
                    .accessibilityLabel("Submit coin total")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { loadRound() }
    }

    private func coinButton(cents: Int, index: Int) -> some View {
        Button {
            purseCents += cents
            beltCoins.remove(at: index)
            SoundEffects.playTap()
            Haptics.tap()
        } label: {
            VStack {
                Text(coinEmoji(cents))
                    .font(.largeTitle)
                Text(coinLabel(cents))
                    .font(AppTypography.caption)
            }
            .frame(width: 72, height: 72)
            .background(AppTheme.card)
            .clipShape(Circle())
        }
        .appTappableStyle()
        .accessibilityLabel("Add \(coinLabel(cents))")
    }

    private func submit() {
        if purseCents == targetCents {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Perfect change!"
            SoundEffects.playCorrect()
            Haptics.success()
            advance()
        } else {
            shake = true
            sparkyMood = .encouraging
            sparkySpeech = purseCents > targetCents ? "That's too much." : "Keep adding coins."
            SoundEffects.playIncorrect()
            Haptics.error()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { shake = false }
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
        targetCents = GameContent.coinTargetCents(grade: grade)
        purseCents = 0
        beltCoins = (0..<8).map { _ in [1, 5, 10, 25, grade == .third ? 100 : 25].randomElement()! }.shuffled()
    }

    private func moneyString(_ cents: Int) -> String {
        String(format: "$%.2f", Double(cents) / 100)
    }

    private func coinEmoji(_ cents: Int) -> String {
        switch cents {
        case 1: return "🪙"
        case 5: return "🟤"
        case 10: return "⚪"
        case 25: return "🟡"
        default: return "💵"
        }
    }

    private func coinLabel(_ cents: Int) -> String {
        switch cents {
        case 1: return "1¢"
        case 5: return "5¢"
        case 10: return "10¢"
        case 25: return "25¢"
        default: return "$1"
        }
    }
}

private struct ShakeEffect: GeometryEffect {
    var animating: Bool
    var animatableData: CGFloat {
        get { animating ? 1 : 0 }
        set { _ = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let offset = animating ? sin(animatableData * .pi * 8) * 6 : 0
        return ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
    }
}
