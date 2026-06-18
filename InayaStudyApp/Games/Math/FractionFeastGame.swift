import SwiftUI

struct FractionFeastGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 8
    private let accent = AppTheme.color(hex: "E67E22")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var targetNum = 1
    @State private var targetDenom = 2
    @State private var slices = 2
    @State private var shaded = 0
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Shade the right slices!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .fractionFeast,
            grade: grade,
            subject: subject,
            title: "Fraction Feast",
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
                Text("Show \(targetNum)/\(targetDenom)")
                    .font(AppTypography.hero)

                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.25))
                        .frame(width: 220, height: 220)
                    ForEach(0..<slices, id: \.self) { index in
                        pizzaSlice(index: index, total: slices)
                    }
                }
                .accessibilityLabel("Pizza with \(slices) slices, \(shaded) shaded")

                HStack(spacing: 16) {
                    Button("More slices") {
                        slices = min(8, slices + 1)
                        shaded = min(shaded, slices)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Add slice division")

                    Button("Fewer slices") {
                        slices = max(2, slices - 1)
                        shaded = min(shaded, slices)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Remove slice division")
                }

                Text("Tap slices to shade (\(shaded)/\(slices))")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)

                Button("Check pizza") { check() }
                    .font(AppTypography.sectionTitle)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { loadRound() }
    }

    @ViewBuilder
    private func pizzaSlice(index: Int, total: Int) -> some View {
        let start = Angle.degrees(Double(index) / Double(total) * 360 - 90)
        let end = Angle.degrees(Double(index + 1) / Double(total) * 360 - 90)
        Button {
            if shaded == index { shaded = max(0, shaded - 1) }
            else { shaded = index + 1 }
            Haptics.tap()
        } label: {
            Path { path in
                path.move(to: CGPoint(x: 110, y: 110))
                path.addArc(center: CGPoint(x: 110, y: 110), radius: 100, startAngle: start, endAngle: end, clockwise: false)
                path.closeSubpath()
            }
            .fill(index < shaded ? Color.red.opacity(0.75) : Color.clear)
            .frame(width: 220, height: 220)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Slice \(index + 1)")
    }

    private func check() {
        guard slices == targetDenom, shaded == targetNum else {
            sparkyMood = .encouraging
            sparkySpeech = slices != targetDenom ? "Cut into \(targetDenom) equal slices." : "Shade \(targetNum) slices."
            SoundEffects.playIncorrect()
            Haptics.error()
            return
        }
        score += 1
        sparkyMood = .celebrating
        SoundEffects.playCorrect()
        Haptics.success()
        if round >= totalRounds { showComplete = true }
        else {
            round += 1
            loadRound()
        }
    }

    private func loadRound() {
        let f = GameContent.fractionPrompt(grade: grade)
        targetNum = f.numerator
        targetDenom = f.denominator
        slices = targetDenom
        shaded = 0
        sparkySpeech = "Show \(targetNum)/\(targetDenom)"
    }
}
