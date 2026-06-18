import SwiftUI

struct NumberLineJumpGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 10
    private let accent = AppTheme.color(hex: "2ECC71")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var jump = (start: 0, delta: 0, answer: 0)
    @State private var selected: Int?
    @State private var retries = 0
    @State private var frogBounce = false
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Where does the frog land?"

    private var lineRange: ClosedRange<Int> {
        grade == .second ? 0...100 : -50...1000
    }

    private var tickStep: Int { grade == .second ? 10 : 50 }

    var body: some View {
        SuiteGameWrapper(
            gameID: .numberLineJump,
            grade: grade,
            subject: subject,
            title: "Number Line Jump",
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
                Text(promptText)
                    .font(AppTypography.question)
                    .multilineTextAlignment(.center)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(Array(stride(from: lineRange.lowerBound, through: min(lineRange.upperBound, jump.start + 200), by: tickStep)), id: \.self) { tick in
                            VStack(spacing: 4) {
                                if tick == jump.start {
                                    Text("🐸")
                                        .font(.title2)
                                        .scaleEffect(frogBounce ? 1.2 : 1)
                                } else if tick == selected {
                                    Circle()
                                        .fill(Color.green.opacity(0.5))
                                        .frame(width: 28, height: 28)
                                } else {
                                    Spacer().frame(height: 28)
                                }
                                Rectangle()
                                    .fill(Color.secondary.opacity(0.4))
                                    .frame(width: 2, height: 16)
                                Button("\(tick)") {
                                    selected = tick
                                    check(tick)
                                }
                                .font(AppTypography.caption)
                                .buttonStyle(.plain)
                                .accessibilityLabel("Number \(tick)")
                            }
                            .frame(width: 44)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(AppTheme.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { loadRound() }
    }

    private var promptText: String {
        let op = jump.delta >= 0 ? "+" : "−"
        return "Start at \(jump.start), jump \(op) \(abs(jump.delta)). Where do you land?"
    }

    private func check(_ value: Int) {
        if value == jump.answer {
            withAnimation(.spring()) { frogBounce = true }
            score += 1
            SoundEffects.playCorrect()
            Haptics.success()
            sparkyMood = .celebrating
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                frogBounce = false
                advance()
            }
        } else {
            retries += 1
            SoundEffects.playIncorrect()
            Haptics.error()
            if retries >= 2 {
                sparkySpeech = "The answer is \(jump.answer)."
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { advance() }
            }
        }
    }

    private func advance() {
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        loadRound()
    }

    private func loadRound() {
        jump = GameContent.numberLineJump(grade: grade)
        selected = nil
        retries = 0
        sparkyMood = .thinking
        sparkySpeech = "Tap your answer on the line."
    }
}
