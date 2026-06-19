import SwiftUI

private struct OrganismFrameKey: PreferenceKey {
    static var defaultValue: [String: CGRect] = [:]

    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}

struct FoodWebBuilderGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 3
    private let accent = AppTheme.color(hex: "27AE60")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var ecosystem = ("", [GameContent.FoodOrganism](), [GameContent.FoodEdge]())
    @State private var userEdges: [GameContent.FoodEdge] = []
    @State private var selectedFrom: String?
    @State private var organismFrames: [String: CGRect] = [:]
    @State private var feedback: String?
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Draw arrows for energy flow!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .foodWebBuilder,
            grade: grade,
            subject: subject,
            title: "Food Web Builder",
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
                Text(ecosystem.0)
                    .font(AppTypography.sectionTitle)

                instructionBanner

                ZStack {
                    Canvas { context, _ in
                        for edge in userEdges {
                            drawArrow(context: &context, from: edge.from, to: edge.to)
                        }
                    }
                    .allowsHitTesting(false)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                        ForEach(ecosystem.1) { org in
                            organismButton(org)
                        }
                    }
                }
                .coordinateSpace(name: "foodWeb")
                .frame(minHeight: 240)
                .onPreferenceChange(OrganismFrameKey.self) { organismFrames = $0 }

                if !userEdges.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your arrows")
                            .font(AppTypography.caption)
                            .foregroundStyle(.secondary)
                        ForEach(Array(userEdges.enumerated()), id: \.offset) { _, edge in
                            HStack(spacing: 6) {
                                Text(organismLabel(edge.from))
                                Image(systemName: "arrow.right")
                                    .font(.caption.bold())
                                    .foregroundStyle(accent)
                                Text(organismLabel(edge.to))
                            }
                            .font(AppTypography.caption)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(AppTheme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if let feedback {
                    Text(feedback)
                        .font(AppTypography.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: 12) {
                    if !userEdges.isEmpty {
                        Button("Undo last") { undoLastEdge() }
                            .font(AppTypography.bodyEmphasis)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(AppTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .appTappableStyle()
                    }

                    Button("Check web") { validate() }
                        .font(AppTypography.sectionTitle)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .appTappableStyle()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { loadEcosystem() }
    }

    private var instructionBanner: some View {
        VStack(spacing: 6) {
            Text("How to build the chain")
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
            Text(instructionText)
                .font(AppTypography.bodyEmphasis)
                .multilineTextAlignment(.center)
                .foregroundStyle(accent)
            Text(exampleText)
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(accent.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var instructionText: String {
        if let from = selectedFrom {
            return "Now tap who gets energy from \(organismLabel(from))."
        }
        return "Tap the energy source, then tap who eats it."
    }

    private var exampleText: String {
        "Example: Sun → Grass → Rabbit = tap Sun, Grass, then Grass, Rabbit."
    }

    private func organismButton(_ org: GameContent.FoodOrganism) -> some View {
        let isSelected = selectedFrom == org.id
        return Button {
            tapOrganism(org.id)
        } label: {
            VStack(spacing: 4) {
                Text(org.emoji).font(.largeTitle)
                Text(org.label)
                    .font(AppTypography.caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 88)
            .background(isSelected ? accent.opacity(0.35) : AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? accent : Color.clear, lineWidth: 3)
            )
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: OrganismFrameKey.self,
                        value: [org.id: geo.frame(in: .named("foodWeb"))]
                    )
                }
            )
        }
        .appTappableStyle()
        .accessibilityLabel(org.label)
    }

    private func tapOrganism(_ id: String) {
        Haptics.tap()
        if selectedFrom == id {
            selectedFrom = nil
            sparkySpeech = "Pick the first part of the chain."
            return
        }
        if let from = selectedFrom, from != id {
            let edge = GameContent.FoodEdge(from: from, to: id)
            if userEdges.contains(edge) {
                feedback = "You already drew that arrow."
                selectedFrom = nil
                return
            }
            userEdges.append(edge)
            selectedFrom = nil
            feedback = nil
            sparkyMood = .thinking
            sparkySpeech = "Arrow added! Keep going or tap Check web."
        } else {
            selectedFrom = id
            sparkySpeech = "Now tap who gets energy from \(organismLabel(id))."
        }
    }

    private func undoLastEdge() {
        guard !userEdges.isEmpty else { return }
        userEdges.removeLast()
        feedback = nil
        Haptics.tap()
    }

    private func organismLabel(_ id: String) -> String {
        ecosystem.1.first { $0.id == id }?.label ?? id
    }

    private func drawArrow(context: inout GraphicsContext, from: String, to: String) {
        guard let fromRect = organismFrames[from], let toRect = organismFrames[to] else { return }
        let start = CGPoint(x: fromRect.midX, y: fromRect.midY)
        let end = CGPoint(x: toRect.midX, y: toRect.midY)

        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        context.stroke(path, with: .color(accent), lineWidth: 3)

        let angle = atan2(end.y - start.y, end.x - start.x)
        let headLength: CGFloat = 10
        let headAngle: CGFloat = .pi / 7
        var head = Path()
        head.move(to: end)
        head.addLine(to: CGPoint(
            x: end.x - headLength * cos(angle - headAngle),
            y: end.y - headLength * sin(angle - headAngle)
        ))
        head.move(to: end)
        head.addLine(to: CGPoint(
            x: end.x - headLength * cos(angle + headAngle),
            y: end.y - headLength * sin(angle + headAngle)
        ))
        context.stroke(head, with: .color(accent), lineWidth: 3)
    }

    private func validate() {
        let required = Set(ecosystem.2)
        let drawn = Set(userEdges)
        if drawn == required {
            score += 1
            feedback = "Great web! Energy flows from sun to producers to consumers."
            SoundEffects.playCorrect()
            Haptics.success()
            sparkyMood = .celebrating
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if round >= totalRounds { showComplete = true }
                else {
                    round += 1
                    loadEcosystem()
                }
            }
        } else if required.isSubset(of: drawn) {
            feedback = "You have extra arrows. Undo wrong ones, then check again."
            SoundEffects.playIncorrect()
            Haptics.error()
        } else {
            feedback = "Some arrows are missing. Follow Sun → plant → animal."
            SoundEffects.playIncorrect()
            Haptics.error()
        }
    }

    private func loadEcosystem() {
        let pack = GameContent.foodWebEcosystem(grade: grade, index: round - 1)
        ecosystem = pack
        userEdges = []
        selectedFrom = nil
        feedback = nil
        sparkySpeech = "Tap one card, then the next in the food chain."
    }
}
