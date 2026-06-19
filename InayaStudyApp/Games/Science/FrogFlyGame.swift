import SwiftUI

struct FrogFlyGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 10
    private let accent = AppTheme.color(hex: "00B894")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var flyRound = GameContent.FrogFlyRound(question: "", insects: [])
    @State private var insectOffset: CGFloat = -200
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Tap the right insect!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .frogFly,
            grade: grade,
            subject: subject,
            title: "Frog Fly",
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
                Text(flyRound.question)
                    .font(AppTypography.question)
                    .multilineTextAlignment(.center)

                GeometryReader { geo in
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(accent.opacity(0.15))

                        Text("🪷")
                            .font(.system(size: 48))
                            .position(x: geo.size.width * 0.5, y: geo.size.height * 0.88)

                        Text("🐸")
                            .font(.system(size: 56))
                            .position(x: geo.size.width * 0.5, y: geo.size.height * 0.78)

                        HStack(spacing: 12) {
                            ForEach(flyRound.insects.indices, id: \.self) { index in
                                let insect = flyRound.insects[index]
                                Button {
                                    tapInsect(insect.isCorrect)
                                } label: {
                                    VStack(spacing: 4) {
                                        Text("🪰")
                                            .font(.title)
                                        Text(insect.label)
                                            .font(AppTypography.caption)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.7)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 72, height: 72)
                                    .background(AppTheme.card)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .appTappableStyle()
                            }
                        }
                        .offset(x: insectOffset)
                        .position(x: geo.size.width * 0.5, y: geo.size.height * 0.35)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func loadRound() {
        flyRound = GameContent.frogFlyRound(grade: grade, round: round)
        insectOffset = -180
        animateInsects()
    }

    private func animateInsects() {
        withAnimation(.linear(duration: 4.0)) {
            insectOffset = 180
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.2) {
            guard !showComplete else { return }
            sparkySpeech = "Too slow — insects flew away!"
            loadRound()
        }
    }

    private func tapInsect(_ correct: Bool) {
        if correct {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Gulp!"
            SoundEffects.playCorrect()
            Haptics.success()
            advance()
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "Wrong bug!"
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
