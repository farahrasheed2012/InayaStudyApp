import SwiftUI

struct DailyChallengeGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    @EnvironmentObject private var gameStore: GameSessionStore
    @EnvironmentObject private var profileStore: UserProfileStore

    private let accent = AppTheme.color(hex: "E74C3C")

    @State private var question: (question: String, choices: [String], correct: String) = ("", [], "")
    @State private var answered = false
    @State private var wasCorrect = false
    @State private var showComplete = false
    @State private var startedAt = Date()

    var body: some View {
        Group {
            if showComplete {
                completionView
            } else if gameStore.dailyStreak().completedToday && !answered {
                alreadyDoneView
            } else {
                challengeView
            }
        }
        .navigationTitle("Daily Challenge")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            question = GameContent.dailyChallengeQuestion(grade: grade)
        }
    }

    private var challengeView: some View {
        VStack(spacing: 24) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                Text("Streak: \(gameStore.dailyStreak().current)")
                    .font(AppTypography.sectionTitle)
            }

            Text("Today's Challenge")
                .font(AppTypography.hero)

            Text(question.question)
                .font(AppTypography.question)
                .multilineTextAlignment(.center)

            GameChoiceGrid(choices: question.choices, accent: accent, layout: .fill) { choice in
                guard !answered else { return }
                answered = true
                wasCorrect = choice == question.correct
                if wasCorrect {
                    SoundEffects.playCelebration()
                    Haptics.success()
                } else {
                    SoundEffects.playIncorrect()
                    Haptics.error()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showComplete = true
                }
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gameScreenCanvas()
    }

    private var alreadyDoneView: some View {
        VStack(spacing: 16) {
            Image(systemName: "flame.fill")
                .font(.system(size: 64))
                .foregroundStyle(.orange)
            Text("You already finished today's challenge!")
                .font(AppTypography.sectionTitle)
                .multilineTextAlignment(.center)
            Text("Streak: \(gameStore.dailyStreak().current) days")
                .font(AppTypography.body)
            Spacer()
        }
        .padding()
    }

    private var completionView: some View {
        SuiteGameCompleteView(
            gameID: .dailyChallenge,
            grade: grade,
            subject: subject,
            title: "Daily Challenge",
            score: wasCorrect ? 1 : 0,
            totalRounds: 1,
            durationSeconds: max(1, Int(Date().timeIntervalSince(startedAt))),
            studentName: profileStore.studentName,
            accent: accent,
            onPlayAgain: { }
        )
    }
}
