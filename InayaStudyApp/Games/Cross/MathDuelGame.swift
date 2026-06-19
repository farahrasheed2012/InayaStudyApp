import SwiftUI

struct MathDuelGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    @EnvironmentObject private var profileStore: UserProfileStore

    private let totalRounds = 10
    private let accent = AppTheme.color(hex: "0984E3")

    @State private var round = 1
    @State private var score = 0
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var problem = ("", 0)
    @State private var choices: [Int] = []
    @State private var player1Wins = 0
    @State private var player2Wins = 0
    @State private var roundLocked = false
    @State private var lastWinner: Int?
    @State private var sparkyMood: SparkyMood = .excited
    @State private var sparkySpeech: String? = "Pass the device — first tap wins!"

    var body: some View {
        Group {
            if showComplete {
                SuiteGameCompleteView(
                    gameID: .mathDuel,
                    grade: grade,
                    subject: subject,
                    title: "Math Duel",
                    score: max(player1Wins, player2Wins),
                    totalRounds: totalRounds,
                    durationSeconds: max(1, Int(Date().timeIntervalSince(startedAt))),
                    studentName: profileStore.studentName,
                    accent: accent,
                    onPlayAgain: restart
                )
            } else {
                duelView
            }
        }
        .navigationTitle("Math Duel")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear { loadRound() }
    }

    private var duelView: some View {
        VStack(spacing: 0) {
            HStack {
                scorePill(label: "Player 1", wins: player1Wins, color: accent)
                Spacer()
                Text("Round \(round)/\(totalRounds)")
                    .font(AppTypography.caption)
                Spacer()
                scorePill(label: "Player 2", wins: player2Wins, color: AppTheme.color(hex: "E84393"))
            }
            .padding()

            GeometryReader { geo in
                VStack(spacing: 0) {
                    playerZone(
                        label: "Player 1",
                        color: accent,
                        height: geo.size.height * 0.5,
                        flip: true
                    )
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 3)
                    playerZone(
                        label: "Player 2",
                        color: AppTheme.color(hex: "E84393"),
                        height: geo.size.height * 0.5,
                        flip: false
                    )
                }
            }

            if let lastWinner {
                Text("Player \(lastWinner) wins the round!")
                    .font(AppTypography.label)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
        }
        .gameScreenCanvas()
    }

    private func scorePill(label: String, wins: Int, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(AppTypography.caption)
            Text("\(wins)")
                .font(AppTypography.cardTitle)
                .foregroundStyle(color)
        }
    }

    private func playerZone(label: String, color: Color, height: CGFloat, flip: Bool) -> some View {
        VStack(spacing: 12) {
            if flip {
                Text(label)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
                Text(problem.0 + " = ?")
                    .font(AppTypography.question)
                    .rotationEffect(.degrees(180))
                choiceRow(color: color, player: 1)
                    .rotationEffect(.degrees(180))
            } else {
                Text(label)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
                Text(problem.0 + " = ?")
                    .font(AppTypography.question)
                choiceRow(color: color, player: 2)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .padding(.horizontal, 12)
    }

    private func choiceRow(color: Color, player: Int) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(choices, id: \.self) { value in
                Button {
                    submit(value, player: player)
                } label: {
                    Text("\(value)")
                        .font(AppTypography.answer)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(color.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.5), lineWidth: 2))
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                }
                .appTappableStyle()
                .disabled(roundLocked)
            }
        }
    }

    private func submit(_ value: Int, player: Int) {
        guard !roundLocked else { return }
        roundLocked = true
        if value == problem.1 {
            if player == 1 { player1Wins += 1 } else { player2Wins += 1 }
            lastWinner = player
            SoundEffects.playCorrect()
            Haptics.success()
            sparkyMood = .celebrating
        } else {
            lastWinner = nil
            SoundEffects.playIncorrect()
            Haptics.error()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if round >= totalRounds {
                score = max(player1Wins, player2Wins)
                showComplete = true
            } else {
                round += 1
                loadRound()
            }
        }
    }

    private func loadRound() {
        let p = GameContent.mathProblem(grade: grade)
        problem = (p.prompt, p.answer)
        choices = GameContent.mathDistractors(correct: p.answer, grade: grade)
        roundLocked = false
        lastWinner = nil
    }

    private func restart() {
        round = 1
        score = 0
        player1Wins = 0
        player2Wins = 0
        showComplete = false
        startedAt = Date()
        loadRound()
    }
}
