import SwiftUI

struct MeteorMathGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 12
    private let accent = AppTheme.color(hex: "E17055")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var meteorRound = GameContent.MeteorRound(target: 0, operation: .add, meteors: [])
    @State private var selectedIndices = Set<Int>()
    @State private var meteorProgress: CGFloat = 0
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Tap two meteors!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .meteorMath,
            grade: grade,
            subject: subject,
            title: "Meteor Math",
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
                let opLabel = meteorRound.operation == .add ? "add to" : "multiply to"
                Text("Make \(meteorRound.target) — tap two numbers that \(opLabel) \(meteorRound.target)")
                    .font(AppTypography.quizMeta)
                    .multilineTextAlignment(.center)

                Text("🌍")
                    .font(.system(size: 48))

                GeometryReader { geo in
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.2))

                        ForEach(meteorRound.meteors.indices, id: \.self) { index in
                            let value = meteorRound.meteors[index]
                            let xFrac = CGFloat((index * 41 + 7) % 85) / 100 + 0.08
                            Button {
                                tapMeteor(at: index)
                            } label: {
                                Text("\(value)")
                                    .font(AppTypography.answer)
                                    .frame(width: 52, height: 52)
                                    .background(selectedIndices.contains(index) ? accent : AppTheme.card)
                                    .foregroundStyle(selectedIndices.contains(index) ? .white : .primary)
                                    .clipShape(Circle())
                            }
                            .appTappableStyle()
                            .position(
                                x: geo.size.width * xFrac,
                                y: geo.size.height * (0.15 + meteorProgress * 0.7)
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func loadRound() {
        meteorRound = GameContent.meteorRound(grade: grade, round: round)
        selectedIndices = []
        meteorProgress = 0
        animateMeteors()
    }

    private func fallDuration() -> Double {
        let base = grade == .second ? 11.0 : 9.5
        let minimum = grade == .second ? 7.0 : 6.0
        return max(base - Double(score) * 0.03, minimum)
    }

    private func animateMeteors() {
        let duration = fallDuration()
        withAnimation(.linear(duration: duration)) {
            meteorProgress = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            guard !showComplete, selectedIndices.count < 2 else { return }
            sparkySpeech = "Meteors hit Earth — try faster!"
            SoundEffects.playIncorrect()
            loadRound()
        }
    }

    private func tapMeteor(at index: Int) {
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
        } else if selectedIndices.count < 2 {
            selectedIndices.insert(index)
        }
        Haptics.tap()
        guard selectedIndices.count == 2 else { return }
        let nums = selectedIndices.sorted().map { meteorRound.meteors[$0] }
        let result: Int
        switch meteorRound.operation {
        case .add: result = nums[0] + nums[1]
        case .multiply: result = nums[0] * nums[1]
        }
        if result == meteorRound.target {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Blasted!"
            SoundEffects.playCorrect()
            Haptics.success()
            advance()
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "That makes \(result), not \(meteorRound.target)."
            SoundEffects.playIncorrect()
            Haptics.error()
            selectedIndices = []
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
