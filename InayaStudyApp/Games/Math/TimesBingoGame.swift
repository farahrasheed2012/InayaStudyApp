import SwiftUI

struct TimesBingoGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let totalRounds = 3
    private let accent = AppTheme.color(hex: "9B59B6")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var card: [Int] = []
    @State private var marked = Set<Int>()
    @State private var call: (a: Int, b: Int, product: Int) = (1, 1, 1)
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Find the product!"

    var body: some View {
        SuiteGameWrapper(
            gameID: .timesBingo,
            grade: grade,
            subject: subject,
            title: "Times Table Bingo",
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
                Text("\(call.a) × \(call.b)")
                    .font(AppTypography.hero)
                    .accessibilityLabel("Problem \(call.a) times \(call.b)")

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                    ForEach(card.indices, id: \.self) { index in
                        let value = card[index]
                        Button {
                            tapCell(index: index, value: value)
                        } label: {
                            Text("\(value)")
                                .font(AppTypography.answer)
                                .frame(maxWidth: .infinity, minHeight: 52)
                                .background(marked.contains(index) ? accent.opacity(0.3) : AppTheme.card)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    if marked.contains(index) {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(AppTheme.star)
                                    }
                                }
                        }
                        .appTappableStyle()
                        .accessibilityLabel("Cell \(value)")
                    }
                }

                if bingoWon {
                    Text("BINGO!")
                        .font(AppTypography.hero)
                        .foregroundStyle(accent)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { newCard() }
    }

    private var bingoWon: Bool {
        let lines: [[Int]] = [
            [0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15],
            [0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15],
            [0, 5, 10, 15], [3, 6, 9, 12],
        ]
        return lines.contains { line in line.allSatisfy { marked.contains($0) } }
    }

    private func tapCell(index: Int, value: Int) {
        guard !marked.contains(index) else { return }
        if value == call.product {
            marked.insert(index)
            SoundEffects.playCorrect()
            Haptics.success()
            if bingoWon {
                score += 1
                sparkyMood = .celebrating
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    if round >= totalRounds { showComplete = true }
                    else {
                        round += 1
                        newCard()
                    }
                }
            } else {
                call = GameContent.bingoCall(grade: grade)
            }
        } else {
            SoundEffects.playIncorrect()
            Haptics.error()
        }
    }

    private func newCard() {
        card = GameContent.bingoProducts(grade: grade)
        marked = []
        call = GameContent.bingoCall(grade: grade)
        while !card.contains(call.product) {
            call = GameContent.bingoCall(grade: grade)
        }
        sparkyMood = .thinking
    }
}
