import SwiftUI

struct TownBuilderGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    @EnvironmentObject private var builderStore: BuilderStore

    private let totalRounds = 8
    private let accent = AppTheme.color(hex: "D35400")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var phase: Phase = .quiz
    @State private var problem = ("", [String](), "", 0, 0, 0)
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Solve problems, build your town!"

    private enum Phase { case quiz, build }

    var body: some View {
        SuiteGameWrapper(
            gameID: .townBuilder,
            grade: grade,
            subject: subject,
            title: "Town Builder",
            totalRounds: totalRounds,
            round: $round,
            score: $score,
            showComplete: $showComplete,
            startedAt: startedAt,
            sparkyMood: sparkyMood,
            sparkySpeech: sparkySpeech,
            accent: accent
        ) {
            VStack(spacing: 14) {
                materialsBar
                if phase == .quiz {
                    quizView
                } else {
                    buildView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadQuiz() }
    }

    private var state: TownBuildState {
        builderStore.townState(grade: grade)
    }

    private var materialsBar: some View {
        HStack(spacing: 12) {
            Label("\(state.lumber) 🪵", systemImage: "tree.fill")
            Label("\(state.bricks) 🧱", systemImage: "square.fill")
            Label("\(state.glass) 🪟", systemImage: "window.vertical.open")
            Spacer()
            Text("\(state.placedBuildings.count) built")
                .font(AppTypography.caption)
        }
        .font(AppTypography.caption)
    }

    private var quizView: some View {
        VStack(spacing: 16) {
            Text(problem.0)
                .font(AppTypography.question)
                .multilineTextAlignment(.center)
            GameChoiceGrid(choices: problem.1, accent: accent, layout: .fill) { pick in
                answerQuiz(pick)
            }
        }
    }

    private var buildView: some View {
        VStack(spacing: 12) {
            Text("Place a building")
                .font(AppTypography.quizMeta)

            let placed = state.placedBuildings
            HStack(spacing: 8) {
                ForEach(placed, id: \.self) { id in
                    if let b = GameContent.townBuildings.first(where: { $0.id == id }) {
                        Text(b.emoji)
                            .font(.title)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .padding(8)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            ForEach(GameContent.townBuildings) { building in
                let canAfford = state.lumber >= building.lumber
                    && state.bricks >= building.bricks
                    && state.glass >= building.glass
                Button {
                    place(building)
                } label: {
                    HStack {
                        Text(building.emoji)
                        Text(building.label)
                            .font(AppTypography.label)
                        Spacer()
                        Text("🪵\(building.lumber) 🧱\(building.bricks) 🪟\(building.glass)")
                            .font(AppTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(canAfford ? AppTheme.card : Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .appTappableStyle()
                .disabled(!canAfford)
            }

            Button("Skip to next problem") { advance() }
                .font(AppTypography.bodyEmphasis)
                .foregroundStyle(.secondary)
                .appTappableStyle()
        }
    }

    private func loadQuiz() {
        phase = .quiz
        let p = GameContent.townBuilderProblem(grade: grade, round: round)
        problem = (p.question, p.choices, p.correct, p.lumber, p.bricks, p.glass)
    }

    private func answerQuiz(_ pick: String) {
        if pick == problem.2 {
            builderStore.addTownMaterials(
                grade: grade,
                lumber: problem.3,
                bricks: problem.4,
                glass: problem.5
            )
            sparkyMood = .celebrating
            sparkySpeech = "Materials earned!"
            SoundEffects.playCorrect()
            Haptics.success()
            phase = .build
        } else {
            sparkyMood = .encouraging
            SoundEffects.playIncorrect()
            Haptics.error()
        }
    }

    private func place(_ building: GameContent.TownBuilding) {
        if builderStore.placeTownBuilding(grade: grade, buildingID: building.id) {
            score += 1
            Haptics.success()
            SoundEffects.playCorrect()
            advance()
        }
    }

    private func advance() {
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        loadQuiz()
        sparkyMood = .thinking
    }
}
