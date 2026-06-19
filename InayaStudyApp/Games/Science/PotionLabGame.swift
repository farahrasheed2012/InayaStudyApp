import SwiftUI

struct PotionLabGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 8
    private let accent = AppTheme.color(hex: "9B59B6")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var potion = GameContent.PotionRound(goal: "", ingredients: [], correctSet: [], minPick: 2, maxPick: 3, failMessage: "")
    @State private var selected = Set<String>()
    @State private var feedback: String?
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Pick ingredients to brew!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .potionLab,
            grade: grade,
            subject: subject,
            title: "Potion Lab",
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
                Text("🧪 \(potion.goal)")
                    .font(AppTypography.sectionTitle)
                    .multilineTextAlignment(.center)

                Text("Pick \(potion.minPick)–\(potion.maxPick) ingredients")
                    .font(AppTypography.quizMeta)

                if let feedback {
                    Text(feedback)
                        .font(AppTypography.studyBody)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(10)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(potion.ingredients, id: \.self) { item in
                        Button {
                            toggle(item)
                        } label: {
                            Text(item)
                                .font(AppTypography.label)
                                .frame(maxWidth: .infinity, minHeight: 52)
                                .background(selected.contains(item) ? accent.opacity(0.35) : AppTheme.card)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .appTappableStyle()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                Button("Brew potion!") { brew() }
                    .font(AppTypography.sectionTitle)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .appTappableStyle()
                    .disabled(selected.count < potion.minPick)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func loadRound() {
        potion = GameContent.potionRound(grade: grade, round: round)
        selected = []
        feedback = nil
        sparkyMood = .thinking
    }

    private func toggle(_ item: String) {
        if selected.contains(item) {
            selected.remove(item)
        } else if selected.count < potion.maxPick {
            selected.insert(item)
        }
        Haptics.tap()
    }

    private func brew() {
        guard selected.count >= potion.minPick, selected.count <= potion.maxPick else { return }
        let validSelection = selected.isSubset(of: potion.correctSet)
        if validSelection {
            score += 1
            feedback = "✨ Perfect brew!"
            sparkyMood = .celebrating
            sparkySpeech = "Bottle on the shelf!"
            SoundEffects.playCorrect()
            Haptics.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { advance() }
        } else {
            feedback = potion.failMessage
            sparkyMood = .encouraging
            sparkySpeech = "Try different ingredients."
            SoundEffects.playIncorrect()
            Haptics.error()
            selected = []
        }
    }

    private func advance() {
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        loadRound()
    }
}
