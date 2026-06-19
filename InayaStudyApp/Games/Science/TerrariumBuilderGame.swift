import SwiftUI

struct TerrariumBuilderGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    @EnvironmentObject private var builderStore: BuilderStore

    private let totalRounds = 8
    private let accent = AppTheme.color(hex: "27AE60")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var phase: Phase = .quiz
    @State private var quiz = ("", [String](), "", GameContent.terrariumPieces[0])
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Earn pieces and build!"

    private enum Phase { case quiz, build }

    var body: some View {
        SuiteGameWrapper(
            gameID: .terrariumBuilder,
            grade: grade,
            subject: subject,
            title: "Terrarium Builder",
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
                inventoryBar
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

    private var state: TerrariumBuildState {
        builderStore.terrariumState(grade: grade)
    }

    private var inventoryBar: some View {
        HStack(spacing: 12) {
            Label("\(state.plants) 🌿", systemImage: "leaf.fill")
            Label("\(state.animals) 🐞", systemImage: "hare.fill")
            Label("\(state.terrain) 🪨", systemImage: "mountain.2.fill")
            Spacer()
            if builderStore.terrariumIsBalanced(grade: grade) {
                Text("Balanced! ✨")
                    .font(AppTypography.caption)
                    .foregroundStyle(accent)
            }
        }
        .font(AppTypography.caption)
    }

    private var quizView: some View {
        VStack(spacing: 16) {
            Text(quiz.0)
                .font(AppTypography.question)
                .multilineTextAlignment(.center)
            GameChoiceGrid(choices: quiz.1, accent: accent, layout: .fill) { pick in
                answerQuiz(pick)
            }
        }
    }

    private var buildView: some View {
        VStack(spacing: 12) {
            Text("Place items in your terrarium")
                .font(AppTypography.quizMeta)

            let placed = state.placedItems
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 56))], spacing: 8) {
                ForEach(placed, id: \.self) { id in
                    if let piece = GameContent.terrariumPieces.first(where: { $0.id == id }) {
                        Text(piece.emoji)
                            .font(.title)
                            .frame(width: 52, height: 52)
                            .background(accent.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .frame(minHeight: 80)
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(GameContent.terrariumPieces) { piece in
                        let canPlace: Bool = {
                            switch piece.kind {
                            case "producer": return state.plants > 0
                            case "consumer": return state.animals > 0
                            default: return state.terrain > 0
                            }
                        }()
                        Button {
                            place(piece)
                        } label: {
                            VStack {
                                Text(piece.emoji)
                                Text(piece.label)
                                    .font(AppTypography.caption)
                            }
                            .padding(8)
                            .background(canPlace ? AppTheme.card : Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .appTappableStyle()
                        .disabled(!canPlace)
                    }
                }
            }

            Button("Finish building") { finishBuild() }
                .font(AppTypography.sectionTitle)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .appTappableStyle()
        }
    }

    private func loadQuiz() {
        phase = .quiz
        let q = GameContent.terrariumQuestion(grade: grade, round: round)
        quiz = (q.question, q.choices, q.correct, q.reward)
    }

    private func answerQuiz(_ pick: String) {
        if pick == quiz.2 {
            let piece = quiz.3
            switch piece.kind {
            case "producer": builderStore.addTerrariumInventory(grade: grade, plants: 1, animals: 0, terrain: 0)
            case "consumer": builderStore.addTerrariumInventory(grade: grade, plants: 0, animals: 1, terrain: 0)
            default: builderStore.addTerrariumInventory(grade: grade, plants: 0, animals: 0, terrain: 1)
            }
            sparkyMood = .celebrating
            sparkySpeech = "Earned \(piece.emoji)!"
            SoundEffects.playCorrect()
            Haptics.success()
            phase = .build
        } else {
            sparkyMood = .encouraging
            SoundEffects.playIncorrect()
            Haptics.error()
        }
    }

    private func place(_ piece: GameContent.TerrariumPiece) {
        if builderStore.placeTerrariumItem(grade: grade, pieceID: piece.id) {
            Haptics.tap()
        }
    }

    private func finishBuild() {
        if builderStore.terrariumIsBalanced(grade: grade) {
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "Living terrarium!"
            advance()
        } else {
            sparkySpeech = "Need more producers than consumers, plus terrain!"
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
        loadQuiz()
        sparkyMood = .thinking
    }
}
