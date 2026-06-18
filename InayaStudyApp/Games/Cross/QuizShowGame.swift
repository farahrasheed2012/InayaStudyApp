import SwiftUI

struct QuizShowGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    private let accent = AppTheme.color(hex: "5B8DEF")
    private let pointValues = [100, 200, 300, 400]
    private let totalRounds = 12

    @EnvironmentObject private var profileStore: UserProfileStore

    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var categories: [String]
    @State private var answered = Set<String>()
    @State private var correctCells = Set<String>()
    @State private var totalPoints = 0
    @State private var activeRound: ActiveRound?

    init(grade: Grade, onComplete: @escaping (GameResult) -> Void) {
        self.grade = grade
        self.onComplete = onComplete
        _categories = State(initialValue: GameContent.quizShowCategories(grade: grade))
    }

    var body: some View {
        Group {
            if let activeRound {
                questionScreen(activeRound)
            } else if showComplete {
                SuiteGameCompleteView(
                    gameID: .quizShow,
                    grade: grade,
                    subject: .math,
                    title: "Quiz Show",
                    score: score,
                    totalRounds: totalRounds,
                    durationSeconds: max(1, Int(Date().timeIntervalSince(startedAt))),
                    studentName: profileStore.studentName,
                    accent: accent,
                    onPlayAgain: restart
                )
            } else {
                boardView
            }
        }
        .navigationTitle("Quiz Show")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var boardView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Score: \(totalPoints)")
                    .font(AppTypography.hero)
                    .frame(maxWidth: .infinity)

                Text("Pick a category and point value")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)

                ForEach(categories, id: \.self) { category in
                    HStack(spacing: 8) {
                        Text(category)
                            .font(AppTypography.caption)
                            .frame(width: 96, alignment: .leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)

                        ForEach(pointValues, id: \.self) { points in
                            boardCell(category: category, points: points)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gameScreenCanvas()
    }

    private func boardCell(category: String, points: Int) -> some View {
        let key = cellKey(category: category, points: points)
        let isAnswered = answered.contains(key)
        let wasCorrect = correctCells.contains(key)

        return Button {
            openCell(category: category, points: points)
        } label: {
            Text("\(points)")
                .font(AppTypography.label)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(cellBackground(answered: isAnswered, correct: wasCorrect))
                .foregroundStyle(isAnswered ? .secondary : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(cellBorder(answered: isAnswered, correct: wasCorrect), lineWidth: 1.5)
                )
                .contentShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .disabled(isAnswered)
        .accessibilityLabel("\(category), \(points) points\(isAnswered ? (wasCorrect ? ", correct" : ", incorrect") : "")")
    }

    private func cellBackground(answered: Bool, correct: Bool) -> Color {
        guard answered else { return accent.opacity(0.22) }
        return correct ? Color.green.opacity(0.35) : AppTheme.danger.opacity(0.28)
    }

    private func cellBorder(answered: Bool, correct: Bool) -> Color {
        guard answered else { return accent.opacity(0.45) }
        return correct ? Color.green.opacity(0.5) : AppTheme.danger.opacity(0.45)
    }

    private func questionScreen(_ round: ActiveRound) -> some View {
        VStack(spacing: 20) {
            Text("\(round.category) — \(round.points)")
                .font(AppTypography.quizMeta)

            Text(round.question)
                .font(AppTypography.question)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            GameChoiceGrid(choices: round.choices, accent: accent, layout: .fill) { choice in
                submitAnswer(choice, for: round)
            }

            Button("Back to board") {
                activeRound = nil
            }
            .font(AppTypography.bodyEmphasis)
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .gameScreenCanvas()
    }

    private func openCell(category: String, points: Int) {
        let key = cellKey(category: category, points: points)
        guard !answered.contains(key) else { return }

        let generated = GameContent.quizShowQuestion(category: category, grade: grade, points: points)
        activeRound = ActiveRound(
            id: key,
            category: category,
            points: points,
            question: generated.question,
            choices: generated.choices,
            correct: generated.correct
        )
        Haptics.tap()
    }

    private func submitAnswer(_ choice: String, for round: ActiveRound) {
        answered.insert(round.id)
        let isCorrect = choice == round.correct
        if isCorrect {
            correctCells.insert(round.id)
            totalPoints += round.points
            score += 1
            SoundEffects.playCorrect()
            Haptics.success()
        } else {
            totalPoints = max(0, totalPoints - round.points / 2)
            SoundEffects.playIncorrect()
            Haptics.error()
        }

        activeRound = nil

        if answered.count >= totalRounds {
            showComplete = true
        }
    }

    private func cellKey(category: String, points: Int) -> String {
        "\(category)-\(points)"
    }

    private func restart() {
        score = 0
        totalPoints = 0
        answered = []
        correctCells = []
        activeRound = nil
        showComplete = false
        startedAt = Date()
        categories = GameContent.quizShowCategories(grade: grade)
    }
}

private struct ActiveRound: Identifiable, Equatable {
    let id: String
    let category: String
    let points: Int
    let question: String
    let choices: [String]
    let correct: String
}
