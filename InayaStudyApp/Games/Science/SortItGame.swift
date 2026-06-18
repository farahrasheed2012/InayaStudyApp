import SwiftUI
import AudioToolbox

struct SortItGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .science
    let onComplete: (GameResult) -> Void

    private let totalRounds = 15
    private let accent = AppTheme.color(hex: "1ABC9C")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var categories: [GameContent.SortCategory] = []
    @State private var cards: [GameContent.SortCard] = []
    @State private var currentIndex = 0
    @State private var dragOffset = CGSize.zero
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Drag to the right bin!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .sortIt,
            grade: grade,
            subject: subject,
            title: "Sort It",
            totalRounds: totalRounds,
            round: $round,
            score: $score,
            showComplete: $showComplete,
            startedAt: startedAt,
            sparkyMood: sparkyMood,
            sparkySpeech: sparkySpeech,
            accent: accent
        ) {
            ScrollView {
                VStack(spacing: 20) {
                if currentIndex < cards.count {
                    let card = cards[currentIndex]
                    Text(card.label)
                        .font(AppTypography.hero)
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .offset(dragOffset)
                        .gesture(dragGesture(for: card))
                        .accessibilityLabel("Card \(card.label). Drag or use buttons below.")

                    tapFallback(for: card)
                } else {
                    Text("Round complete!")
                        .font(AppTypography.sectionTitle)
                }

                HStack(spacing: 10) {
                    ForEach(categories) { cat in
                        VStack {
                            Text(cat.title)
                                .font(AppTypography.label)
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppTheme.color(hex: cat.colorHex).opacity(0.35))
                                .frame(height: 80)
                        }
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Bin \(cat.title)")
                    }
                }
            }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { loadRound() }
    }

    private func dragGesture(for card: GameContent.SortCard) -> some Gesture {
        DragGesture()
            .onChanged { dragOffset = $0.translation }
            .onEnded { value in
                if value.translation.width > 80 { sort(card, toward: categories.last) }
                else if value.translation.width < -80 { sort(card, toward: categories.first) }
                else if categories.count > 2, value.translation.height > 60 { sort(card, toward: categories[1]) }
                dragOffset = .zero
            }
    }

    @ViewBuilder
    private func tapFallback(for card: GameContent.SortCard) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Or tap a bin:")
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
            ForEach(categories) { cat in
                Button(cat.title) { sort(card, toward: cat) }
                    .buttonStyle(.plain)
                    .font(AppTypography.label)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(AppTheme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .contentShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityLabel("Sort into \(cat.title)")
            }
        }
    }

    private func sort(_ card: GameContent.SortCard, toward category: GameContent.SortCategory?) {
        guard let category else { return }
        if card.categoryID == category.id {
            score += 1
            AudioServicesPlaySystemSound(1104)
            Haptics.success()
            sparkyMood = .celebrating
            advanceCard()
        } else {
            SoundEffects.playIncorrect()
            Haptics.error()
            sparkyMood = .encouraging
            sparkySpeech = "Try another bin!"
        }
    }

    private func advanceCard() {
        currentIndex += 1
        round = min(currentIndex + 1, totalRounds)
        if currentIndex >= cards.count || round > totalRounds {
            showComplete = true
        }
    }

    private func loadRound() {
        let pack = GameContent.sortRound(grade: grade)
        categories = pack.categories
        cards = Array(pack.cards.prefix(totalRounds))
        currentIndex = 0
        round = 1
        score = 0
    }
}
