import SwiftUI

struct CreatureCompendiumView: View {
    @EnvironmentObject private var gameStore: GameSessionStore

    @State private var selectedCreature: CollectedCreature?

    private var collected: [CollectedCreature] {
        gameStore.collectedCreatures()
    }

    private var locked: [CreatureDefinition] {
        let unlockedKeys = Set(collected.map(\.creatureKey))
        return CreatureCatalog.all.filter { def in
            !Grade.allCases.contains { grade in
                unlockedKeys.contains(CreatureCatalog.creatureKey(gameID: def.gameID, grade: grade))
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("\(collected.count) of \(CreatureCatalog.all.count * Grade.allCases.count) unlocked")
                        .font(AppTypography.sectionTitle)
                    Spacer()
                }

                if !collected.isEmpty {
                    Text("Your Creatures")
                        .font(AppTypography.cardTitle)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 14)], spacing: 14) {
                        ForEach(collected, id: \.creatureKey) { creature in
                            Button {
                                selectedCreature = creature
                            } label: {
                                creatureCell(emoji: creature.emoji, name: creature.name, locked: false)
                            }
                            .appTappableStyle()
                        }
                    }
                }

                Text("Still to Find")
                    .font(AppTypography.cardTitle)
                Text("Get a perfect score in a game to unlock its creature!")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 14)], spacing: 14) {
                    ForEach(locked) { def in
                        creatureCell(emoji: "❓", name: def.name, locked: true)
                    }
                }
            }
            .contentColumn()
            .padding(.vertical, 16)
        }
        .gameScreenCanvas()
        .navigationTitle("Creature Compendium")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(item: $selectedCreature) { creature in
            VStack(spacing: 20) {
                Text(creature.emoji)
                    .font(.system(size: 72))
                Text(creature.name)
                    .font(AppTypography.hero)
                Text(creature.funFact)
                    .font(AppTypography.studyBody)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("From \(AppGameID(rawValue: creature.gameID)?.title ?? "a game") · \(creature.grade.rawValue)")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
                Button("Done") { selectedCreature = nil }
                    .padding(.top)
            }
            .padding(24)
            .presentationDetents([.medium])
        }
    }

    private func creatureCell(emoji: String, name: String, locked: Bool) -> some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 40))
                .opacity(locked ? 0.35 : 1)
            Text(name)
                .font(AppTypography.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(locked ? .secondary : .primary)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding(8)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .contentShape(RoundedRectangle(cornerRadius: 14))
    }
}

extension CollectedCreature: Identifiable {
    var id: String { creatureKey }
}
