import Foundation
import SwiftData

enum ProgressMigration {
    private static let didMigrateKey = "swiftdata.progress.migrated"

    @MainActor
    static func migrateLegacyJSONIfNeeded(modelContext: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: didMigrateKey) else { return }

        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let fileURL = dir
            .appendingPathComponent("InayaStudyApp", isDirectory: true)
            .appendingPathComponent("progress.json")

        guard let data = try? Data(contentsOf: fileURL),
              let snapshot = try? JSONDecoder().decode(ProgressSnapshot.self, from: data) else {
            UserDefaults.standard.set(true, forKey: didMigrateKey)
            return
        }

        for session in snapshot.sessions {
            let subject: Subject
            if let topic = TopicRegistry.topic(id: session.topicId) {
                subject = topic.subject
            } else if session.topicId.hasPrefix("sci") {
                subject = .science
            } else {
                subject = .math
            }

            let grade = GradeLevel(rawValue: session.grade) ?? .second
            let difficulty = Difficulty(rawValue: session.difficulty) ?? .medium

            modelContext.insert(
                SessionRecord(
                    date: session.date,
                    subject: subject,
                    topicId: session.topicId,
                    grade: grade,
                    difficulty: difficulty,
                    score: session.correctAnswers,
                    totalQuestions: session.totalQuestions
                )
            )

            upsertTopicAccuracy(
                modelContext: modelContext,
                topicId: session.topicId,
                subject: subject,
                correct: session.correctAnswers,
                attempts: session.totalQuestions,
                date: session.date
            )
        }

        let streak = snapshot.streak
        modelContext.insert(
            PracticeStreakData(
                lastPracticedDate: streak.lastPracticedDate,
                currentStreak: streak.currentStreak,
                longestStreak: streak.longestStreak
            )
        )

        try? modelContext.save()
        UserDefaults.standard.set(true, forKey: didMigrateKey)
    }

    @MainActor
    private static func upsertTopicAccuracy(
        modelContext: ModelContext,
        topicId: String,
        subject: Subject,
        correct: Int,
        attempts: Int,
        date: Date
    ) {
        let descriptor = FetchDescriptor<TopicAccuracy>(
            predicate: #Predicate { $0.topicId == topicId }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.correctCount += correct
            existing.attemptCount += attempts
            existing.lastUpdated = max(existing.lastUpdated, date)
        } else {
            modelContext.insert(
                TopicAccuracy(
                    topicId: topicId,
                    subject: subject,
                    correctCount: correct,
                    attemptCount: attempts,
                    lastUpdated: date
                )
            )
        }
    }
}
