import SwiftUI

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
    @State private var dragFrom: String?
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

                ZStack {
                    ForEach(userEdges, id: \.self) { edge in
                        arrowPath(from: edge.from, to: edge.to)
                            .stroke(accent, lineWidth: 3)
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                        ForEach(ecosystem.1) { org in
                            Button {
                                tapOrganism(org.id)
                            } label: {
                                VStack {
                                    Text(org.emoji).font(.largeTitle)
                                    Text(org.label).font(AppTypography.caption)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(dragFrom == org.id ? accent.opacity(0.3) : AppTheme.card)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(org.label)
                        }
                    }
                }
                .frame(minHeight: 220)

                if let feedback {
                    Text(feedback)
                        .font(AppTypography.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Button("Check web") { validate() }
                    .font(AppTypography.sectionTitle)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { loadEcosystem() }
    }

    private func tapOrganism(_ id: String) {
        if let from = dragFrom, from != id {
            userEdges.append(GameContent.FoodEdge(from: from, to: id))
            dragFrom = nil
            Haptics.tap()
        } else {
            dragFrom = id
        }
    }

    private func arrowPath(from: String, to: String) -> Path {
        let positions = gridPositions(count: ecosystem.1.count)
        guard let fi = ecosystem.1.firstIndex(where: { $0.id == from }),
              let ti = ecosystem.1.firstIndex(where: { $0.id == to }) else { return Path() }
        var path = Path()
        path.move(to: positions[fi])
        path.addLine(to: positions[ti])
        return path
    }

    private func gridPositions(count: Int) -> [CGPoint] {
        var points: [CGPoint] = []
        for i in 0..<count {
            let x = CGFloat(40 + (i % 3) * 100)
            let y = CGFloat(40 + (i / 3) * 90)
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }

    private func validate() {
        let required = Set(ecosystem.2)
        let drawn = Set(userEdges)
        if required.isSubset(of: drawn) {
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
        } else {
            feedback = "Some arrows are missing or wrong. Add all energy paths."
            SoundEffects.playIncorrect()
            Haptics.error()
        }
    }

    private func loadEcosystem() {
        let pack = GameContent.foodWebEcosystem(grade: grade, index: round - 1)
        ecosystem = pack
        userEdges = []
        dragFrom = nil
        feedback = nil
        sparkySpeech = "Tap one card, then another to draw an arrow."
    }
}
