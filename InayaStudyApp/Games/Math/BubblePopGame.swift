import SwiftUI

struct BubblePopGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 12
    private let accent = AppTheme.color(hex: "00CEC9")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var bubbleRound = GameContent.BubbleRound(prompt: "", correctAnswers: [], bubbles: [])
    @State private var popped = Set<Int>()
    @State private var bubbleProgress: [CGFloat] = []
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Pop the right bubbles!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .bubblePop,
            grade: grade,
            subject: subject,
            title: "Bubble Pop",
            totalRounds: totalRounds,
            round: $round,
            score: $score,
            showComplete: $showComplete,
            startedAt: startedAt,
            sparkyMood: sparkyMood,
            sparkySpeech: sparkySpeech,
            accent: accent
        ) {
            VStack(spacing: 12) {
                Text(bubbleRound.prompt)
                    .font(AppTypography.question)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                GeometryReader { geo in
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(accent.opacity(0.12))

                        ForEach(bubbleRound.bubbles.indices, id: \.self) { index in
                            if !popped.contains(bubbleRound.bubbles[index]) {
                                bubbleButton(value: bubbleRound.bubbles[index], index: index, size: geo.size)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func bubbleButton(value: Int, index: Int, size: CGSize) -> some View {
        let xFrac = CGFloat((index * 37 + 11) % 80) / 100 + 0.1
        let progress = bubbleProgress.indices.contains(index) ? bubbleProgress[index] : 0
        let yOffset = size.height * (0.85 - progress * 0.9)

        return Button {
            popBubble(value)
        } label: {
            Text("\(value)")
                .font(AppTypography.answer)
                .frame(width: 56, height: 56)
                .background(accent.opacity(0.35))
                .clipShape(Circle())
                .overlay(Circle().stroke(.white.opacity(0.6), lineWidth: 2))
        }
        .appTappableStyle()
        .position(x: size.width * xFrac, y: yOffset)
    }

    private func loadRound() {
        bubbleRound = GameContent.bubbleRound(grade: grade)
        popped = []
        bubbleProgress = Array(repeating: 0, count: bubbleRound.bubbles.count)
        animateBubbles()
    }

    private func riseDuration() -> Double {
        let base = grade == .second ? 10.0 : 8.5
        let minimum = grade == .second ? 6.5 : 5.5
        return max(base - Double(score) * 0.03, minimum)
    }

    private func animateBubbles() {
        let duration = riseDuration()
        for index in bubbleRound.bubbles.indices {
            withAnimation(.linear(duration: duration)) {
                if bubbleProgress.indices.contains(index) {
                    bubbleProgress[index] = 1
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            guard !showComplete else { return }
            if popped != bubbleRound.correctAnswers {
                sparkyMood = .encouraging
                sparkySpeech = "Bubbles escaped — try again!"
                SoundEffects.playIncorrect()
                loadRound()
            }
        }
    }

    private func popBubble(_ value: Int) {
        if bubbleRound.correctAnswers.contains(value) {
            popped.insert(value)
            Haptics.tap()
            SoundEffects.playCorrect()
            if popped == bubbleRound.correctAnswers {
                score += 1
                sparkyMood = .celebrating
                sparkySpeech = "Pop!"
                advance()
            }
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "Wrong bubble!"
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
