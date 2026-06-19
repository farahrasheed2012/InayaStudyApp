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
    @State private var selectedSlices: Set<Int> = []
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Shade the right slices!"

    private var shadedCount: Int { selectedSlices.count }

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

                InteractiveFractionPizza(
                    sliceCount: slices,
                    selectedSlices: selectedSlices,
                    accent: accent
                ) { index in
                    toggleSlice(index)
                }
                .frame(width: 240, height: 240)
                .accessibilityLabel("Pizza with \(slices) slices, \(shadedCount) shaded")

                HStack(spacing: 16) {
                    Button("More slices") {
                        slices = min(8, slices + 1)
                        selectedSlices = selectedSlices.filter { $0 < slices }
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Add slice division")

                    Button("Fewer slices") {
                        slices = max(2, slices - 1)
                        selectedSlices = selectedSlices.filter { $0 < slices }
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Remove slice division")
                }

                Text("Tap slices to shade (\(shadedCount)/\(slices))")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)

                Button("Check pizza") { check() }
                    .font(AppTypography.sectionTitle)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .appTappableStyle()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { loadRound() }
    }

    private func toggleSlice(_ index: Int) {
        if selectedSlices.contains(index) {
            selectedSlices.remove(index)
        } else {
            selectedSlices.insert(index)
        }
        Haptics.tap()
    }

    private func check() {
        guard slices == targetDenom, shadedCount == targetNum else {
            sparkyMood = .encouraging
            sparkySpeech = slices != targetDenom
                ? "Cut into \(targetDenom) equal slices."
                : "Shade \(targetNum) slice\(targetNum == 1 ? "" : "s")."
            SoundEffects.playIncorrect()
            Haptics.error()
            return
        }
        score += 1
        sparkyMood = .celebrating
        SoundEffects.playCorrect()
        Haptics.success()
        if round >= totalRounds {
            showComplete = true
        } else {
            round += 1
            loadRound()
        }
    }

    private func loadRound() {
        let f = GameContent.fractionPrompt(grade: grade)
        targetNum = f.numerator
        targetDenom = f.denominator
        slices = targetDenom
        selectedSlices = []
        sparkySpeech = "Show \(targetNum)/\(targetDenom)"
    }
}

private struct InteractiveFractionPizza: View {
    let sliceCount: Int
    let selectedSlices: Set<Int>
    let accent: Color
    let onSliceTap: (Int) -> Void

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2 - 6

            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = min(size.width, size.height) / 2 - 6

                for index in 0..<sliceCount {
                    let wedge = wedgePath(
                        center: center,
                        radius: radius,
                        index: index,
                        total: sliceCount
                    )
                    let shaded = selectedSlices.contains(index)
                    context.fill(
                        wedge,
                        with: .color(shaded ? accent.opacity(0.85) : Color.white.opacity(0.55))
                    )
                    context.stroke(
                        wedge,
                        with: .color(Color.brown.opacity(0.75)),
                        lineWidth: 2
                    )
                }

                var outline = Path()
                outline.addEllipse(in: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                ))
                context.stroke(outline, with: .color(Color.brown.opacity(0.9)), lineWidth: 3)
            }
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        guard let index = sliceIndex(
                            at: value.location,
                            center: center,
                            radius: radius,
                            total: sliceCount
                        ) else { return }
                        onSliceTap(index)
                    }
            )
        }
    }

    private func wedgePath(center: CGPoint, radius: CGFloat, index: Int, total: Int) -> Path {
        let start = Double(index) / Double(total) * 2 * .pi - .pi / 2
        let end = Double(index + 1) / Double(total) * 2 * .pi - .pi / 2
        var path = Path()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .radians(start),
            endAngle: .radians(end),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }

    private func sliceIndex(at point: CGPoint, center: CGPoint, radius: CGFloat, total: Int) -> Int? {
        let dx = point.x - center.x
        let dy = point.y - center.y
        guard dx * dx + dy * dy <= radius * radius else { return nil }

        var angle = atan2(dy, dx) + .pi / 2
        if angle < 0 { angle += 2 * .pi }
        if angle >= 2 * .pi { angle -= 2 * .pi }

        return Int(angle / (2 * .pi) * Double(total)) % total
    }
}
