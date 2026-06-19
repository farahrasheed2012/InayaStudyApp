import SwiftUI

struct GamesHubView: View {
    @EnvironmentObject private var gameStore: GameSessionStore

    @State private var grade: Grade = .second

    private enum CollectionLink: Hashable {
        case starChart
        case compendium
    }

    private var visibleGames: [AppGameID] {
        AppGameID.allCases.filter { game in
            game != .dailyChallenge && game != .bossBattle && game.isAvailable(for: grade)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                gradePicker
                collectionLinks
                dailyChallengeLink
                bossBattleLink
                Text("Mini-Games")
                    .font(AppTypography.sectionTitle)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 14)], spacing: 14) {
                    ForEach(visibleGames) { game in
                        NavigationLink(value: game) {
                            gameCard(game)
                        }
                        .appTappableStyle()
                    }
                }
            }
            .contentColumn()
            .padding(.vertical, 16)
        }
        .appScreenBackground()
        .preferredColorScheme(.light)
        .navigationTitle("Games")
        .navigationDestination(for: AppGameID.self) { game in
            GameRouter.view(for: game, grade: grade)
        }
        .navigationDestination(for: CollectionLink.self) { link in
            switch link {
            case .starChart: StarChartView()
            case .compendium: CreatureCompendiumView()
            }
        }
    }

    private var collectionLinks: some View {
        let creatureCount = gameStore.creatureCount()
        return HStack(spacing: 12) {
            NavigationLink(value: CollectionLink.starChart) {
                collectionCard(
                    icon: "star.circle.fill",
                    title: "Star Chart",
                    subtitle: "Light up every topic",
                    tint: AppTheme.star
                )
            }
            .appTappableStyle()

            NavigationLink(value: CollectionLink.compendium) {
                collectionCard(
                    icon: "book.fill",
                    title: "Creatures",
                    subtitle: creatureCount > 0 ? "\(creatureCount) collected" : "Unlock with perfect games",
                    tint: AppTheme.color(hex: "2ECC71")
                )
            }
            .appTappableStyle()
        }
    }

    private func collectionCard(icon: String, title: String, subtitle: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(tint)
            Text(title)
                .font(AppTypography.cardTitle)
            Text(subtitle)
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .contentShape(RoundedRectangle(cornerRadius: 18))
    }

    private var gradePicker: some View {
        HStack(spacing: 10) {
            gradePill(.second)
            gradePill(.third)
        }
    }

    private func gradePill(_ value: Grade) -> some View {
        Button {
            withAnimation(.spring()) { grade = value }
        } label: {
            Text(value.rawValue)
                .font(AppTypography.label)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(grade == value ? Color.accentColor : AppTheme.card)
                .foregroundStyle(grade == value ? .white : .primary)
                .clipShape(Capsule())
        }
        .appTappableStyle()
    }

    private var dailyChallengeLink: some View {
        let streak = gameStore.dailyStreak()
        return NavigationLink(value: AppGameID.dailyChallenge) {
            HStack(spacing: 14) {
                ZStack {
                    Image(systemName: "flame.fill")
                        .font(.title)
                        .foregroundStyle(.orange)
                    if !streak.completedToday {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 14, y: -14)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's Challenge")
                        .font(AppTypography.cardTitle)
                    Text(streak.completedToday ? "Completed — streak \(streak.current)" : "Tap to play — streak \(streak.current)")
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.orange.opacity(streak.completedToday ? 0 : 0.5), lineWidth: 2)
            )
            .contentShape(RoundedRectangle(cornerRadius: 18))
        }
        .appTappableStyle()
        .accessibilityLabel("Today's daily challenge")
    }

    @ViewBuilder
    private var bossBattleLink: some View {
        let status = gameStore.bossStatus()
        if status.unlocked {
            NavigationLink(value: AppGameID.bossBattle) {
                bossBattleCard(unlocked: true, sessionsUntil: status.sessionsUntil)
            }
            .appTappableStyle()
            .accessibilityLabel("Boss battle unlocked")
        } else {
            bossBattleCard(unlocked: false, sessionsUntil: status.sessionsUntil)
                .accessibilityLabel("Boss battle locked")
        }
    }

    private func bossBattleCard(unlocked: Bool, sessionsUntil: Int) -> some View {
        HStack(spacing: 14) {
            Image(systemName: unlocked ? "shield.lefthalf.filled" : "lock.fill")
                .font(.title)
                .foregroundStyle(unlocked ? AppTheme.color(hex: "8E44AD") : .secondary)
            VStack(alignment: .leading, spacing: 4) {
                Text("Boss Battle")
                    .font(AppTypography.cardTitle)
                Text(unlocked ? "Ready to fight!" : "\(sessionsUntil) sessions until boss")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if unlocked {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .contentShape(RoundedRectangle(cornerRadius: 18))
    }

    private func gameCard(_ game: AppGameID) -> some View {
        let best = gameStore.bestScore(gameID: game, grade: grade)
        let isNew = !gameStore.hasPlayed(gameID: game)
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: game.icon)
                    .font(.title2)
                    .foregroundStyle(scopeColor(game.scope))
                Spacer()
                if isNew {
                    Text("New!")
                        .font(AppTypography.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            Text(game.title)
                .font(AppTypography.cardTitle)
                .multilineTextAlignment(.leading)
            HStack {
                Text(game.scope.label)
                    .font(AppTypography.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(scopeColor(game.scope).opacity(0.15))
                    .clipShape(Capsule())
                Text(grade.rawValue)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }
            if let best {
                Text("Best: \(best)/\(game.totalRounds)")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .leading)
        .background(AppTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .contentShape(RoundedRectangle(cornerRadius: 18))
        .accessibilityLabel("\(game.title), \(game.scope.label), \(grade.rawValue)")
    }

    private func scopeColor(_ scope: GameSubjectScope) -> Color {
        switch scope {
        case .math: return AppTheme.color(hex: "5B8DEF")
        case .science: return AppTheme.color(hex: "2ECC71")
        case .both: return AppTheme.color(hex: "9B59B6")
        }
    }
}
