import SwiftUI

struct AnimalRescueGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 6
    private let accent = AppTheme.color(hex: "E67E22")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var scenario = GameContent.RescueScenario(
        animal: "", emoji: "", question: "", correctHabitat: "", wrongHabitats: [], funnyWrong: [:]
    )
    @State private var feedback: String?
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Help the baby animal get home!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .animalRescue,
            grade: grade,
            subject: subject,
            title: "Animal Rescue",
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
                Text("🆘 Animal Rescue")
                    .font(AppTypography.quizMeta)

                Text(scenario.emoji)
                    .font(.system(size: 80))

                Text("A \(scenario.animal) is lost!")
                    .font(AppTypography.sectionTitle)
                    .multilineTextAlignment(.center)

                Text(scenario.question)
                    .font(AppTypography.question)
                    .multilineTextAlignment(.center)

                if let feedback {
                    Text(feedback)
                        .font(AppTypography.studyBody)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                let choices = ([scenario.correctHabitat] + scenario.wrongHabitats).shuffled()
                GameChoiceGrid(
                    choices: choices,
                    accent: accent,
                    layout: .fill
                ) { choice in
                    pick(choice)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func loadRound() {
        scenario = GameContent.rescueScenario(grade: grade, index: round - 1)
        feedback = nil
        sparkyMood = .thinking
    }

    private func pick(_ choice: String) {
        if choice == scenario.correctHabitat {
            feedback = "Home safe! Great job, rescuer!"
            score += 1
            sparkyMood = .celebrating
            sparkySpeech = "You saved the day!"
            SoundEffects.playCorrect()
            Haptics.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                if round >= totalRounds {
                    showComplete = true
                } else {
                    round += 1
                    loadRound()
                }
            }
        } else {
            feedback = scenario.funnyWrong[choice] ?? "Hmm, that doesn't look right. Try again!"
            sparkyMood = .encouraging
            SoundEffects.playIncorrect()
            Haptics.error()
        }
    }
}
