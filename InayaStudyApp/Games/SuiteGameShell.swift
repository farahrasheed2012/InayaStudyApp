import SwiftUI

struct SuiteGameWrapper<Content: View>: View {
    let gameID: AppGameID
    let grade: Grade
    let subject: Subject
    let title: String
    let totalRounds: Int
    @Binding var round: Int
    @Binding var score: Int
    @Binding var showComplete: Bool
    let startedAt: Date
    let sparkyMood: SparkyMood
    let sparkySpeech: String?
    let accent: Color
    @ViewBuilder var content: () -> Content

    @EnvironmentObject private var profileStore: UserProfileStore

    var body: some View {
        Group {
            if showComplete {
                SuiteGameCompleteView(
                    gameID: gameID,
                    grade: grade,
                    subject: subject,
                    title: title,
                    score: score,
                    totalRounds: totalRounds,
                    durationSeconds: max(1, Int(Date().timeIntervalSince(startedAt))),
                    studentName: profileStore.studentName,
                    accent: accent,
                    onPlayAgain: { showComplete = false }
                )
            } else {
                VStack(spacing: 0) {
                    suiteHeader
                    progressBar
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    content()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                }
                .gameScreenCanvas()
            }
        }
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var suiteHeader: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTypography.quizMeta)
                Text("Round \(min(round, totalRounds)) of \(totalRounds)")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 4) {
                ForEach(0..<min(totalRounds, 12), id: \.self) { index in
                    Image(systemName: index < score ? "star.fill" : "star")
                        .foregroundStyle(index < score ? AppTheme.star : .secondary.opacity(0.35))
                        .font(.caption2)
                }
            }
            CharacterView(mood: sparkyMood, size: 48, speechText: sparkySpeech, showSpeechBubble: false)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 6)
    }

    private var progressBar: some View {
        GameProgressBar(
            progress: Double(min(round, totalRounds)) / Double(max(totalRounds, 1)),
            accent: accent
        )
        .animation(.easeOut(duration: 0.35), value: round)
    }
}

struct SuiteGameCompleteView: View {
    let gameID: AppGameID
    let grade: Grade
    let subject: Subject
    let title: String
    let score: Int
    let totalRounds: Int
    let durationSeconds: Int
    let studentName: String
    let accent: Color
    let onPlayAgain: () -> Void

    @EnvironmentObject private var gameStore: GameSessionStore
    @Environment(\.dismiss) private var dismiss

    @State private var earnedBadge: GameBadgeAward?
    @State private var earnedCreature: CreatureAward?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            CharacterView(
                mood: score >= totalRounds - 1 ? .celebrating : .encouraging,
                size: 120,
                speechText: message
            )
            Text("\(title) complete!")
                .font(AppTypography.hero)
            HStack(spacing: 8) {
                ForEach(0..<min(totalRounds, 12), id: \.self) { index in
                    Image(systemName: index < score ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundStyle(index < score ? AppTheme.star : .secondary.opacity(0.3))
                }
            }
            Text("Score: \(score) / \(totalRounds)")
                .font(AppTypography.sectionTitle)
            if let earnedBadge {
                Label("Badge earned: \(earnedBadge.label)", systemImage: earnedBadge.symbolName)
                    .font(AppTypography.bodyEmphasis)
                    .foregroundStyle(accent)
            }
            if let earnedCreature {
                VStack(spacing: 6) {
                    Text(earnedCreature.emoji)
                        .font(.system(size: 48))
                    Text("New creature: \(earnedCreature.name)!")
                        .font(AppTypography.bodyEmphasis)
                        .foregroundStyle(accent)
                }
            }
            Spacer()
            VStack(spacing: 12) {
                Button(action: onPlayAgain) {
                    Label("Play again", systemImage: "arrow.clockwise")
                        .font(AppTypography.sectionTitle)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .appTappableStyle()
                Button("Back to games") { dismiss() }
                    .font(AppTypography.bodyEmphasis)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gameScreenCanvas()
        .onAppear {
            let result = gameStore.recordCompletion(
                gameID: gameID,
                grade: grade,
                subject: subject,
                score: score,
                totalRounds: totalRounds,
                durationSeconds: durationSeconds
            )
            earnedBadge = result.earnedBadge
            earnedCreature = result.earnedCreature
            if score >= 3 { SoundEffects.playCelebration() }
            else if score >= 1 { SoundEffects.playStarEarned() }
            SpeechManager.shared.speakPraise(name: studentName, subject: subject)
        }
    }

    private var message: String {
        if score == totalRounds { return "Perfect, \(studentName)!" }
        if score >= totalRounds - 1 { return "So close — amazing!" }
        return "Nice playing, \(studentName)!"
    }
}

struct GameChoiceGrid: View {
    let choices: [String]
    let accent: Color
    var layout: GameChoiceGridLayout = .standard
    let onSelect: (String) -> Void

    private var minButtonHeight: CGFloat {
        layout == .fill ? 80 : 56
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Array(choices.enumerated()), id: \.offset) { _, choice in
                Button {
                    onSelect(choice)
                } label: {
                    Text(choice)
                        .font(AppTypography.answer)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, minHeight: minButtonHeight)
                        .background(AppTheme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(accent.opacity(0.35), lineWidth: 2)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 14))
                }
                .appTappableStyle()
                .accessibilityLabel("Answer \(choice)")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: layout == .fill ? .infinity : nil, alignment: .center)
    }
}
