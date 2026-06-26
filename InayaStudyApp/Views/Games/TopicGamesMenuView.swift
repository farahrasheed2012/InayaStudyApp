import SwiftUI

struct TopicGamesMenuView: View {
    let topic: Topic

    @EnvironmentObject private var profileStore: UserProfileStore

    private var accent: Color { TopicAccent(topic: topic).color }
    private var games: [TopicGameKind] { TopicGameRegistry.games(for: topic) }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                topicHeader

                CharacterView(
                    mood: .excited,
                    size: 88,
                    speechText: "Pick a game, \(profileStore.studentName)! No pressure — just fun."
                )

                Text("Mini-Games")
                    .font(AppTypography.sectionTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(games) { game in
                    NavigationLink {
                        TopicGameViews.root(for: game, topic: topic)
                            .appScreenBackground()
                    } label: {
                        gameCard(game)
                    }
                    .appTappableStyle()
                }
            }
            .padding(20)
        }
        .fullWidthContent()
        .appScreenBackground()
        .navigationTitle("Play to Learn")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var topicHeader: some View {
        HStack(spacing: 14) {
            Image(systemName: topic.icon)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(accent)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.name)
                    .font(AppTypography.sectionTitle)
                Text("TEKS \(topic.teks)")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func gameCard(_ game: TopicGameKind) -> some View {
        HStack(spacing: 16) {
            Image(systemName: game.icon)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(accent)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 6) {
                Text(game.title)
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(.primary)
                Text(game.subtitle)
                    .font(AppTypography.studyBody)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(accent.opacity(0.35), lineWidth: 2)
        )
        .contentShape(RoundedRectangle(cornerRadius: 18))
    }
}
