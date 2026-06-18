import Foundation
import SwiftData

@MainActor
final class ProgressStore: ObservableObject {
    @Published private(set) var revision = 0

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        ProgressMigration.migrateLegacyJSONIfNeeded(modelContext: modelContext)
        ensureStreakRow()
    }

    func recordSession(topic: Topic, difficulty: Difficulty, total: Int, correct: Int) {
        modelContext.insert(
            SessionRecord(
                subject: topic.subject,
                topicId: topic.id,
                grade: topic.grade,
                difficulty: difficulty,
                score: correct,
                totalQuestions: total
            )
        )

        upsertTopicAccuracy(topic: topic, correct: correct, attempts: total)
        updateStreak()
        save()
    }

    func accuracy(for topicId: String) -> Double {
        let descriptor = FetchDescriptor<TopicAccuracy>(
            predicate: #Predicate { $0.topicId == topicId }
        )
        guard let row = try? modelContext.fetch(descriptor).first, row.attemptCount > 0 else {
            return 0
        }
        return Double(row.correctCount) / Double(row.attemptCount)
    }

    func totalProblemsSolved() -> Int {
        let descriptor = FetchDescriptor<SessionRecord>()
        let sessions = (try? modelContext.fetch(descriptor)) ?? []
        return sessions.reduce(0) { $0 + $1.totalQuestions }
    }

    func recentTopicIDs(limit: Int = 3) -> [String] {
        var descriptor = FetchDescriptor<SessionRecord>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let sessions = (try? modelContext.fetch(descriptor)) ?? []
        var seen = Set<String>()
        var result: [String] = []
        for session in sessions where !seen.contains(session.topicId) {
            seen.insert(session.topicId)
            result.append(session.topicId)
            if result.count >= limit { break }
        }
        return result
    }

    func streak() -> (current: Int, longest: Int) {
        let row = fetchStreak()
        return (row.currentStreak, row.longestStreak)
    }

    func lastPracticedDate() -> Date {
        fetchStreak().lastPracticedDate
    }

    func strongestAndWeakest(in topics: [Topic]) -> (strongest: Topic?, weakest: Topic?) {
        let withData = topics.map { ($0, accuracy(for: $0.id)) }.filter { $0.1 > 0 }
        guard !withData.isEmpty else { return (nil, nil) }
        let strongest = withData.max(by: { $0.1 < $1.1 })?.0
        let weakest = withData.min(by: { $0.1 < $1.1 })?.0
        return (strongest, weakest)
    }

    func recentSessions(subject: Subject, difficulty: Difficulty, limit: Int = 3) -> [SessionRecord] {
        let subjectRaw = subject.rawValue
        let difficultyRaw = difficulty.rawValue
        var descriptor = FetchDescriptor<SessionRecord>(
            predicate: #Predicate {
                $0.subjectRaw == subjectRaw && $0.difficultyRaw == difficultyRaw
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func bestSessionAccuracy(for topicId: String) -> Double {
        let descriptor = FetchDescriptor<SessionRecord>(
            predicate: #Predicate { $0.topicId == topicId }
        )
        let sessions = (try? modelContext.fetch(descriptor)) ?? []
        let best = sessions.compactMap { session -> Double? in
            guard session.totalQuestions > 0 else { return nil }
            return Double(session.score) / Double(session.totalQuestions)
        }.max()
        return best ?? accuracy(for: topicId)
    }

    func resetAll() {
        deleteAll(SessionRecord.self)
        deleteAll(TopicAccuracy.self)
        deleteAll(PracticeStreakData.self)
        deleteAll(DifficultyNudgeRecord.self)
        ensureStreakRow()
        save()
    }

    func hasShownDifficultyNudge(key: String) -> Bool {
        let descriptor = FetchDescriptor<DifficultyNudgeRecord>(
            predicate: #Predicate { $0.nudgeKey == key }
        )
        return ((try? modelContext.fetch(descriptor).first) != nil)
    }

    func markDifficultyNudgeShown(key: String) {
        guard !hasShownDifficultyNudge(key: key) else { return }
        modelContext.insert(DifficultyNudgeRecord(nudgeKey: key))
        save()
    }

    private func upsertTopicAccuracy(topic: Topic, correct: Int, attempts: Int) {
        let topicId = topic.id
        let descriptor = FetchDescriptor<TopicAccuracy>(
            predicate: #Predicate { $0.topicId == topicId }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.correctCount += correct
            existing.attemptCount += attempts
            existing.lastUpdated = .now
        } else {
            modelContext.insert(
                TopicAccuracy(
                    topicId: topic.id,
                    subject: topic.subject,
                    correctCount: correct,
                    attemptCount: attempts
                )
            )
        }
    }

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let row = fetchStreak()
        let last = calendar.startOfDay(for: row.lastPracticedDate)

        if last == today {
            return
        }

        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today), last == yesterday {
            row.currentStreak += 1
        } else if last < today {
            row.currentStreak = 1
        }

        row.longestStreak = max(row.longestStreak, row.currentStreak)
        row.lastPracticedDate = .now
        save()
    }

    private func ensureStreakRow() {
        if fetchStreakIfExists() == nil {
            modelContext.insert(PracticeStreakData())
            save()
        }
    }

    private func fetchStreakIfExists() -> PracticeStreakData? {
        let descriptor = FetchDescriptor<PracticeStreakData>(
            predicate: #Predicate { $0.key == "main" }
        )
        return try? modelContext.fetch(descriptor).first
    }

    private func fetchStreak() -> PracticeStreakData {
        if let row = fetchStreakIfExists() {
            return row
        }
        let row = PracticeStreakData()
        modelContext.insert(row)
        save()
        return row
    }

    private func deleteAll<T: PersistentModel>(_ type: T.Type) {
        let descriptor = FetchDescriptor<T>()
        let rows = (try? modelContext.fetch(descriptor)) ?? []
        rows.forEach { modelContext.delete($0) }
    }

    private func save() {
        try? modelContext.save()
        revision += 1
    }
}
