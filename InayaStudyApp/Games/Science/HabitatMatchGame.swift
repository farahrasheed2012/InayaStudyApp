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
    @State private var selectedHabitat: String?
    @State private var matched = Set<UUID>()
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Match each animal to its home."

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
                instructionBanner

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

    private var instructionBanner: some View {
        VStack(spacing: 6) {
            Text("How to play")
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
            Text(instructionText)
                .font(AppTypography.bodyEmphasis)
                .multilineTextAlignment(.center)
                .foregroundStyle(accent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(accent.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var instructionText: String {
        if matched.count == pairs.count, !pairs.isEmpty {
            return "Nice matching!"
        }
        if let animal = selectedAnimal {
            return "Tap the habitat where \(animal.emoji) \(animal.animal) lives."
        }
        if selectedHabitat != nil {
            return "Tap the animal that lives in \(selectedHabitat!)."
        }
        return "Tap an animal and its habitat — either order works!"
    }

    private var uniqueHabitats: [String] {
        Array(Set(pairs.map(\.habitat))).sorted()
    }

    private func habitatEmoji(for habitat: String) -> String {
        pairs.first { $0.habitat == habitat }?.habitatEmoji ?? "🌍"
    }

    private func animalButton(_ pair: GameContent.HabitatPair) -> some View {
        let isMatched = matched.contains(pair.id)
        let isSelected = selectedAnimal?.id == pair.id
        return Button {
            guard !isMatched else { return }
            Haptics.tap()
            if selectedHabitat != nil {
                selectedAnimal = pair
                checkMatch()
            } else {
                selectedAnimal = pair
                selectedHabitat = nil
                sparkyMood = .thinking
                sparkySpeech = "Now tap \(pair.animal)'s habitat."
            }
        } label: {
            HStack {
                Text(pair.emoji)
                Text(pair.animal)
                    .font(AppTypography.label)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.horizontal, 8)
            .background(isMatched ? Color.green.opacity(0.25) : (isSelected ? accent.opacity(0.35) : AppTheme.card))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? accent : Color.clear, lineWidth: 3)
            )
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .appTappableStyle()
        .disabled(isMatched)
    }

    private func habitatButton(_ habitat: String) -> some View {
        let isSelected = selectedHabitat == habitat
        return Button {
            Haptics.tap()
            if selectedAnimal != nil {
                selectedHabitat = habitat
                checkMatch()
            } else {
                selectedHabitat = habitat
                selectedAnimal = nil
                sparkyMood = .thinking
                sparkySpeech = "Now tap the animal that lives in \(habitat)."
            }
        } label: {
            HStack {
                Text(habitatEmoji(for: habitat))
                Text(habitat)
                    .font(AppTypography.label)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.horizontal, 8)
            .background(isSelected ? accent.opacity(0.35) : AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? accent : Color.clear, lineWidth: 3)
            )
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .appTappableStyle()
    }

    private func checkMatch() {
        guard let animal = selectedAnimal, let habitat = selectedHabitat else { return }

        if animal.habitat == habitat {
            matched.insert(animal.id)
            selectedAnimal = nil
            selectedHabitat = nil
            SoundEffects.playCorrect()
            Haptics.success()
            sparkyMood = .celebrating
            sparkySpeech = "Perfect match!"
            if matched.count == pairs.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { advanceRound() }
            }
        } else {
            sparkyMood = .encouraging
            sparkySpeech = "\(animal.animal) doesn't live in \(habitat). Try again!"
            SoundEffects.playIncorrect()
            Haptics.error()
            selectedAnimal = nil
            selectedHabitat = nil
        }
    }

    private func loadRound() {
        pairs = GameContent.habitatRound(grade: grade)
        matched = []
        selectedAnimal = nil
        selectedHabitat = nil
        sparkyMood = .thinking
        sparkySpeech = "Match each animal to its home."
    }

    private func advanceRound() {
        score += 1
        if round >= totalRounds {
            showComplete = true
            return
        }
        round += 1
        loadRound()
    }
}
