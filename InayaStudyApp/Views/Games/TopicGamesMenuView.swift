import SwiftUI

struct TopicGamesMenuView: View {
    let topic: Topic

    @EnvironmentObject private var profileStore: UserProfileStore
    @State private var showGame = false
    @State private var gameToLaunch: TopicGameKind = .sparkyMatch

    private var accent: Color { TopicAccent(topic: topic).color }
    private var games: [TopicGameKind] { TopicGameRegistry.games(for: topic) }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CharacterView(
                    mood: .excited,
                    size: 88,
                    speechText: "Games help you learn, \(profileStore.studentName)! No pressure — just fun."
                )

                ForEach(games) { game in
                    Button {
                        gameToLaunch = game
                        showGame = true
                    } label: {
                        gameCard(game)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .fullWidthContent()
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Play to Learn")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationDestination(isPresented: $showGame) {
            TopicGameViews.root(for: gameToLaunch, topic: topic)
        }
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
