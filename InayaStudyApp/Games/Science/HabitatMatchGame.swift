import SwiftUI

struct HabitatMatchGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 8
    private let accent = AppTheme.color(hex: "27AE60")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var pairs: [GameContent.HabitatPair] = []
    @State private var selectedAnimal: GameContent.HabitatPair?
    @State private var matched = Set<UUID>()
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Tap an animal, then its habitat!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .habitatMatch,
            grade: grade,
            subject: subject,
            title: "Habitat Match",
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
                Text("Match each animal to its home")
                    .font(AppTypography.quizMeta)

                HStack(alignment: .top, spacing: 16) {
                    VStack(spacing: 10) {
                        Text("Animals")
                            .font(AppTypography.caption)
                            .foregroundStyle(.secondary)
                        ForEach(pairs) { pair in
                            animalButton(pair)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: 10) {
                        Text("Habitats")
                            .font(AppTypography.caption)
                            .foregroundStyle(.secondary)
                        ForEach(uniqueHabitats, id: \.self) { habitat in
                            habitatButton(habitat)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                if matched.count == pairs.count, !pairs.isEmpty {
                    Text("Round complete! 🎉")
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(accent)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private var uniqueHabitats: [String] {
        Array(Set(pairs.map(\.habitat))).sorted()
    }

    private func animalButton(_ pair: GameContent.HabitatPair) -> some View {
        let isMatched = matched.contains(pair.id)
        let isSelected = selectedAnimal?.id == pair.id
        return Button {
            guard !isMatched else { return }
            selectedAnimal = pair
            Haptics.tap()
        } label: {
            HStack {
                Text(pair.emoji)
                Text(pair.animal)
                    .font(AppTypography.label)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .padding(.horizontal, 8)
            .background(isMatched ? Color.green.opacity(0.25) : (isSelected ? accent.opacity(0.3) : AppTheme.card))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(isMatched)
    }

    private func habitatButton(_ habitat: String) -> some View {
        let emoji = pairs.first { $0.habitat == habitat }?.habitatEmoji ?? "🌍"
        return Button {
            guard let animal = selectedAnimal else { return }
            if animal.habitat == habitat {
                matched.insert(animal.id)
                selectedAnimal = nil
                SoundEffects.playCorrect()
                Haptics.success()
                sparkyMood = .celebrating
                if matched.count == pairs.count {
                    score += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { advanceRound() }
                }
            } else {
                sparkyMood = .encouraging
                sparkySpeech = "Try a different habitat!"
                SoundEffects.playIncorrect()
                Haptics.error()
            }
        } label: {
            HStack {
                Text(emoji)
                Text(habitat)
                    .font(AppTypography.label)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private func loadRound() {
        pairs = GameContent.habitatRound(grade: grade)
        matched = []
        selectedAnimal = nil
        sparkyMood = .thinking
    }

    private func advanceRound() {
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        loadRound()
    }
}
