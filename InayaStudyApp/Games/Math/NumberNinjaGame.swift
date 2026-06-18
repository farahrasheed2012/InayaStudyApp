import SwiftUI

struct NumberNinjaGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    @EnvironmentObject private var profileStore: UserProfileStore

    private let totalRounds = 20
    private let accent = AppTheme.color(hex: "E74C3C")

    @State private var round = 1
    @State private var score = 0
    @State private var lives = 3
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var problem = ("", 0)
    @State private var choices: [Int] = []
    @State private var blockProgress: CGFloat = 0
    @State private var slashVisible = false
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Slash the right answer!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .numberNinja,
            grade: grade,
            subject: subject,
            title: "Number Ninja",
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
                HStack {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < lives ? "heart.fill" : "heart")
                            .foregroundStyle(AppTheme.danger)
                    }
                    Spacer()
                    Text("Speed: \(1 + score / 5)")
                        .font(AppTypography.caption)
                }

                GeometryReader { geo in
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(accent.opacity(0.15))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(AppTheme.card)
                                .frame(width: min(geo.size.width * 0.55, 260), height: min(geo.size.height * 0.28, 96))
                                .overlay(
                                    Text(problem.0)
                                        .font(AppTypography.question)
                                        .minimumScaleFactor(0.7)
                                )
                                .offset(y: blockYOffset(in: geo.size.height))

                            if slashVisible {
                                Path { path in
                                    path.move(to: CGPoint(x: geo.size.width * 0.2, y: geo.size.height * 0.25))
                                    path.addLine(to: CGPoint(x: geo.size.width * 0.8, y: geo.size.height * 0.75))
                                }
                                .stroke(Color.white, lineWidth: 4)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                GameChoiceGrid(
                    choices: choices.map(String.init),
                    accent: accent,
                    layout: .fill
                ) { pick in
                    answer(Int(pick) ?? -1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadProblem() }
        .onChange(of: round) { _, _ in animateBlock() }
    }

    private func blockYOffset(in height: CGFloat) -> CGFloat {
        let travel = height * 0.55
        let start = -height * 0.22
        return start + (travel * blockProgress)
    }

    private func loadProblem() {
        let p = GameContent.mathProblem(grade: grade)
        problem = (p.prompt, p.answer)
        choices = GameContent.mathDistractors(correct: p.answer, grade: grade)
        blockProgress = 0
        animateBlock()
    }

    private func animateBlock() {
        let duration = max(2.5 - Double(score / 5) * 0.2, 1.2)
        withAnimation(.linear(duration: duration)) {
            blockProgress = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            guard !showComplete, lives > 0 else { return }
            if blockProgress >= 0.95 {
                loseLife()
            }
        }
    }

    private func answer(_ value: Int) {
        if value == problem.1 {
            slashVisible = true
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Slash!"
            SoundEffects.playCorrect()
            Haptics.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                slashVisible = false
                if round >= totalRounds {
                    showComplete = true
                } else {
                    round += 1
                    loadProblem()
                    sparkyMood = .thinking
                }
            }
        } else {
            withAnimation { blockProgress = min(1, blockProgress + 0.18) }
            sparkyMood = .encouraging
            SoundEffects.playIncorrect()
            Haptics.error()
            if blockProgress >= 0.95 { loseLife() }
        }
    }

    private func loseLife() {
        lives -= 1
        if lives <= 0 || round >= totalRounds {
            showComplete = true
            return
        }
        loadProblem()
    }
}
