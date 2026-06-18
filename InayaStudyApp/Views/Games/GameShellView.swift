import SwiftUI

struct GameShellView<Content: View>: View {
    let title: String
    let topic: Topic
    let round: Int
    let totalRounds: Int
    let score: Int
    let sparkyMood: SparkyMood
    let sparkySpeech: String?
    @ViewBuilder var content: () -> Content

    private var accent: Color { TopicAccent(topic: topic).color }

    var body: some View {
        VStack(spacing: 0) {
            header
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

    private var header: some View {
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
                ForEach(0..<totalRounds, id: \.self) { index in
                    Image(systemName: index < score ? "star.fill" : "star")
                        .foregroundStyle(index < score ? AppTheme.star : .secondary.opacity(0.35))
                        .font(.caption)
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

struct GameCompleteView: View {
    let topic: Topic
    let score: Int
    let totalRounds: Int
    let studentName: String
    let onPlayAgain: () -> Void

    @Environment(\.dismiss) private var dismiss

    private var accent: Color { TopicAccent(topic: topic).color }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            CharacterView(
                mood: score >= totalRounds - 1 ? .celebrating : .encouraging,
                size: 120,
                speechText: message
            )
            Text("Game complete!")
                .font(AppTypography.hero)
            HStack(spacing: 8) {
                ForEach(0..<totalRounds, id: \.self) { index in
                    Image(systemName: index < score ? "star.fill" : "star")
                        .font(.title)
                        .foregroundStyle(index < score ? AppTheme.star : .secondary.opacity(0.3))
                }
            }
            Text("You got \(score) out of \(totalRounds)!")
                .font(AppTypography.sectionTitle)
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
                .buttonStyle(.plain)

                NavigationLink {
                    SessionSetupView(topic: topic)
                } label: {
                    Label("Try Practice for stars", systemImage: "star.fill")
                        .font(AppTypography.sectionTitle)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(AppTheme.card)
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(accent.opacity(0.4), lineWidth: 2)
                        )
                }
                .buttonStyle(.plain)

                Button("Back to topic") { dismiss() }
                    .font(AppTypography.bodyEmphasis)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gameScreenCanvas()
        .onAppear {
            if score >= 3 {
                SoundEffects.playCelebration()
            } else if score >= 1 {
                SoundEffects.playStarEarned()
            }
            SpeechManager.shared.speakPraise(name: studentName, subject: topic.subject)
        }
    }

    private var message: String {
        if score == totalRounds { return "Perfect game, \(studentName)!" }
        if score >= totalRounds - 1 { return "So close — amazing!" }
        if score >= 2 { return "Nice playing, \(studentName)!" }
        return "Keep trying — you've got this!"
    }
}
