import SwiftUI

struct BossBattleGame: View, GameScene {
    let grade: Grade
    let subject: Subject = .math
    let onComplete: (GameResult) -> Void

    @EnvironmentObject private var gameStore: GameSessionStore
    @EnvironmentObject private var profileStore: UserProfileStore

    private let totalRounds = 5
    private let accent = AppTheme.color(hex: "8E44AD")

    @State private var round = 1
    @State private var score = 0
    @State private var hearts = 3
    @State private var showComplete = false
    @State private var startedAt = Date()
    @State private var bossHealth: Double = 1
    @State private var question: (question: String, choices: [String], correct: String) = ("", [], "")
    @State private var sparkyMood: SparkyMood = .thinking
    @State private var sparkySpeech: String? = "Defeat the boss!"
    @State private var bossShake = false

    var body: some View {
        Group {
            let status = gameStore.bossStatus()
            if !status.unlocked {
                lockedView(sessionsUntil: status.sessionsUntil)
            } else if status.onCooldown {
                cooldownView
            } else if showComplete {
                SuiteGameCompleteView(
                    gameID: .bossBattle,
                    grade: grade,
                    subject: subject,
                    title: "Boss Battle",
                    score: score,
                    totalRounds: totalRounds,
                    durationSeconds: max(1, Int(Date().timeIntervalSince(startedAt))),
                    studentName: profileStore.studentName,
                    accent: accent,
                    onPlayAgain: restart
                )
                .onAppear {
                    let defeated = score >= 4 && hearts > 0
                    gameStore.markBossAttempt(defeated: defeated)
                }
            } else {
                battleView
            }
        }
        .navigationTitle("Boss Battle")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear { loadQuestion() }
    }

    private var battleView: some View {
        VStack(spacing: 16) {
            HStack {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < hearts ? "heart.fill" : "heart")
                        .foregroundStyle(AppTheme.danger)
                }
                Spacer()
                Text("Boss HP")
                    .font(AppTypography.caption)
            }

            GeometryReader { geo in
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(accent.opacity(0.2))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Text("🐉")
                        .font(.system(size: min(geo.size.width, geo.size.height) * 0.45))
                        .offset(x: bossShake ? 8 : 0)
                    VStack {
                        Spacer()
                        GameProgressBar(progress: bossHealth, accent: AppTheme.danger)
                            .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Text(question.question)
                .font(AppTypography.question)
                .multilineTextAlignment(.center)

            GameChoiceGrid(choices: question.choices, accent: accent, layout: .fill) { choice in
                answer(choice)
            }

            CharacterView(mood: sparkyMood, size: 48, speechText: sparkySpeech, showSpeechBubble: false)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gameScreenCanvas()
    }

    private func lockedView(sessionsUntil: Int) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill")
                .font(.largeTitle)
            Text("Boss Battle locked")
                .font(AppTypography.sectionTitle)
            Text("\(sessionsUntil) more game sessions until the boss appears.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private var cooldownView: some View {
        VStack(spacing: 16) {
            Text("🐉")
                .font(.system(size: 64))
            Text("The boss escaped!")
                .font(AppTypography.sectionTitle)
            Text("Try again tomorrow.")
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private func answer(_ choice: String) {
        if choice == question.correct {
            score += 1
            bossHealth = max(0, bossHealth - 0.2)
            withAnimation(.default) { bossShake.toggle() }
            SoundEffects.playCorrect()
            Haptics.success()
            sparkyMood = .celebrating
        } else {
            hearts -= 1
            Haptics.error()
            SoundEffects.playIncorrect()
            sparkyMood = .encouraging
        }

        if hearts <= 0 || round >= totalRounds || bossHealth <= 0 {
            showComplete = true
            if hearts <= 0 { gameStore.markBossAttempt(defeated: false) }
            return
        }
        round += 1
        loadQuestion()
    }

    private func loadQuestion() {
        question = GameContent.bossQuestion(grade: grade, index: round - 1)
    }

    private func restart() {
        round = 1
        score = 0
        hearts = 3
        bossHealth = 1
        showComplete = false
        startedAt = Date()
        loadQuestion()
    }
}
