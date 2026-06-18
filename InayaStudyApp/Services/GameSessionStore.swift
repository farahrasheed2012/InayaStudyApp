import Foundation
import SwiftData

@MainActor
final class GameSessionStore: ObservableObject {
    private let modelContext: ModelContext

    @Published private(set) var revision = 0

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func recordCompletion(
        gameID: AppGameID,
        grade: Grade,
        subject: Subject,
        score: Int,
        totalRounds: Int,
        durationSeconds: Int
    ) -> GameResult {
        let session = GameSession(
            gameID: gameID.rawValue,
            grade: grade,
            subject: subject,
            score: score,
            totalRounds: totalRounds,
            durationSeconds: durationSeconds
        )
        modelContext.insert(session)

        var earned: GameBadgeAward?
        if shouldAwardBadge(gameID: gameID, grade: grade, score: score, totalRounds: totalRounds) {
            earned = awardBadge(gameID: gameID, grade: grade)
        }

        var earnedCreature: CreatureAward?
        if shouldAwardCreature(gameID: gameID, grade: grade, score: score, totalRounds: totalRounds) {
            earnedCreature = awardCreature(gameID: gameID, grade: grade)
        }

        if gameID != .bossBattle && gameID != .dailyChallenge {
            incrementBossProgress()
        }

        if gameID == .dailyChallenge, score >= 1 {
            updateDailyStreak()
        }

        save()
        return GameResult(
            score: score,
            totalRounds: totalRounds,
            durationSeconds: durationSeconds,
            earnedBadge: earned,
            earnedCreature: earnedCreature
        )
    }

    func bestScore(gameID: AppGameID, grade: Grade) -> Int? {
        let id = gameID.rawValue
        let gradeRaw = grade.rawValue
        let descriptor = FetchDescriptor<GameSession>(
            predicate: #Predicate { $0.gameID == id && $0.gradeRaw == gradeRaw },
            sortBy: [SortDescriptor(\.score, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor))?.first?.score
    }

    func hasPlayed(gameID: AppGameID) -> Bool {
        let id = gameID.rawValue
        var descriptor = FetchDescriptor<GameSession>(predicate: #Predicate { $0.gameID == id })
        descriptor.fetchLimit = 1
        return ((try? modelContext.fetchCount(descriptor)) ?? 0) > 0
    }

    func totalGameSessions() -> Int {
        (try? modelContext.fetchCount(FetchDescriptor<GameSession>())) ?? 0
    }

    func dailyStreak() -> (current: Int, longest: Int, completedToday: Bool) {
        let row = fetchOrCreateDailyStreak()
        let completedToday = Calendar.current.isDateInToday(row.lastCompletedDate)
        return (row.currentStreak, row.longestStreak, completedToday)
    }

    func bossStatus() -> (unlocked: Bool, sessionsUntil: Int, onCooldown: Bool) {
        let state = fetchOrCreateBossState()
        let unlocked = state.sessionsSinceBoss >= 5
        let sessionsUntil = max(0, 5 - state.sessionsSinceBoss)
        let onCooldown = unlocked
            && Date().timeIntervalSince(state.lastAttemptAt) < 86_400
            && state.lastDefeatAt < state.lastAttemptAt
        return (unlocked, sessionsUntil, onCooldown)
    }

    func markBossAttempt(defeated: Bool) {
        let state = fetchOrCreateBossState()
        state.lastAttemptAt = .now
        if defeated {
            state.sessionsSinceBoss = 0
            state.lastDefeatAt = .now
        }
        save()
    }

    func gameBadges() -> [GameBadge] {
        let descriptor = FetchDescriptor<GameBadge>(sortBy: [SortDescriptor(\.earnedAt, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func collectedCreatures() -> [CollectedCreature] {
        let descriptor = FetchDescriptor<CollectedCreature>(sortBy: [SortDescriptor(\.unlockedAt, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func hasCreature(gameID: AppGameID, grade: Grade) -> Bool {
        let key = CreatureCatalog.creatureKey(gameID: gameID, grade: grade)
        var descriptor = FetchDescriptor<CollectedCreature>(predicate: #Predicate { $0.creatureKey == key })
        descriptor.fetchLimit = 1
        return ((try? modelContext.fetchCount(descriptor)) ?? 0) > 0
    }

    func creatureCount() -> Int {
        (try? modelContext.fetchCount(FetchDescriptor<CollectedCreature>())) ?? 0
    }

    // MARK: - Private

    private func shouldAwardBadge(gameID: AppGameID, grade: Grade, score: Int, totalRounds: Int) -> Bool {
        guard score >= totalRounds else { return false }
        let key = badgeKey(gameID: gameID, grade: grade)
        var descriptor = FetchDescriptor<GameBadge>(predicate: #Predicate { $0.badgeKey == key })
        descriptor.fetchLimit = 1
        return ((try? modelContext.fetchCount(descriptor)) ?? 0) == 0
    }

    private func awardBadge(gameID: AppGameID, grade: Grade) -> GameBadgeAward {
        let key = badgeKey(gameID: gameID, grade: grade)
        let badge = GameBadge(
            badgeKey: key,
            gameID: gameID.rawValue,
            grade: grade,
            label: gameID.badgeLabel,
            symbolName: gameID.icon
        )
        modelContext.insert(badge)
        return GameBadgeAward(id: key, gameID: gameID.rawValue, label: gameID.badgeLabel, symbolName: gameID.icon)
    }

    private func badgeKey(gameID: AppGameID, grade: Grade) -> String {
        "\(gameID.rawValue)-\(grade.rawValue)"
    }

    private func shouldAwardCreature(gameID: AppGameID, grade: Grade, score: Int, totalRounds: Int) -> Bool {
        guard score >= totalRounds, CreatureCatalog.creature(for: gameID) != nil else { return false }
        let key = CreatureCatalog.creatureKey(gameID: gameID, grade: grade)
        var descriptor = FetchDescriptor<CollectedCreature>(predicate: #Predicate { $0.creatureKey == key })
        descriptor.fetchLimit = 1
        return ((try? modelContext.fetchCount(descriptor)) ?? 0) == 0
    }

    private func awardCreature(gameID: AppGameID, grade: Grade) -> CreatureAward? {
        guard let def = CreatureCatalog.creature(for: gameID) else { return nil }
        let key = CreatureCatalog.creatureKey(gameID: gameID, grade: grade)
        let row = CollectedCreature(
            creatureKey: key,
            creatureID: def.id,
            gameID: gameID.rawValue,
            grade: grade,
            name: def.name,
            emoji: def.emoji,
            funFact: def.funFact
        )
        modelContext.insert(row)
        return CreatureAward(id: def.id, name: def.name, emoji: def.emoji, funFact: def.funFact)
    }

    private func incrementBossProgress() {
        let state = fetchOrCreateBossState()
        state.sessionsSinceBoss += 1
    }

    private func updateDailyStreak() {
        let row = fetchOrCreateDailyStreak()
        let cal = Calendar.current
        if cal.isDateInToday(row.lastCompletedDate) { return }

        if let yesterday = cal.date(byAdding: .day, value: -1, to: .now),
           cal.isDate(row.lastCompletedDate, inSameDayAs: yesterday) {
            row.currentStreak += 1
        } else if !cal.isDateInToday(row.lastCompletedDate) {
            row.currentStreak = 1
        }
        row.longestStreak = max(row.longestStreak, row.currentStreak)
        row.lastCompletedDate = .now
    }

    private func fetchOrCreateDailyStreak() -> DailyChallengeStreak {
        if let existing = try? modelContext.fetch(FetchDescriptor<DailyChallengeStreak>()).first {
            return existing
        }
        let row = DailyChallengeStreak()
        modelContext.insert(row)
        return row
    }

    private func fetchOrCreateBossState() -> BossBattleState {
        if let existing = try? modelContext.fetch(FetchDescriptor<BossBattleState>()).first {
            return existing
        }
        let row = BossBattleState()
        modelContext.insert(row)
        return row
    }

    private func save() {
        try? modelContext.save()
        revision += 1
    }
}
