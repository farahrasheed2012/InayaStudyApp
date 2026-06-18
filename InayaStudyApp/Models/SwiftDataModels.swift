import Foundation
import SwiftData

@Model
final class SessionRecord {
    var date: Date
    var subjectRaw: String
    var topicId: String
    var gradeRaw: String
    var difficultyRaw: String
    var score: Int
    var totalQuestions: Int

    init(
        date: Date = .now,
        subject: Subject,
        topicId: String,
        grade: GradeLevel,
        difficulty: Difficulty,
        score: Int,
        totalQuestions: Int
    ) {
        self.date = date
        self.subjectRaw = subject.rawValue
        self.topicId = topicId
        self.gradeRaw = grade.rawValue
        self.difficultyRaw = difficulty.rawValue
        self.score = score
        self.totalQuestions = totalQuestions
    }

    var subject: Subject { Subject(rawValue: subjectRaw) ?? .math }
    var difficulty: Difficulty { Difficulty(rawValue: difficultyRaw) ?? .medium }
}

@Model
final class TopicAccuracy {
    @Attribute(.unique) var topicId: String
    var subjectRaw: String
    var correctCount: Int
    var attemptCount: Int
    var lastUpdated: Date

    init(
        topicId: String,
        subject: Subject,
        correctCount: Int = 0,
        attemptCount: Int = 0,
        lastUpdated: Date = .now
    ) {
        self.topicId = topicId
        self.subjectRaw = subject.rawValue
        self.correctCount = correctCount
        self.attemptCount = attemptCount
        self.lastUpdated = lastUpdated
    }

    var subject: Subject { Subject(rawValue: subjectRaw) ?? .math }
}

@Model
final class PracticeStreakData {
    @Attribute(.unique) var key: String
    var lastPracticedDate: Date
    var currentStreak: Int
    var longestStreak: Int

    init(
        key: String = "main",
        lastPracticedDate: Date = .distantPast,
        currentStreak: Int = 0,
        longestStreak: Int = 0
    ) {
        self.key = key
        self.lastPracticedDate = lastPracticedDate
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
    }
}

@Model
final class DifficultyNudgeRecord {
    @Attribute(.unique) var nudgeKey: String
    var shownAt: Date

    init(nudgeKey: String, shownAt: Date = .now) {
        self.nudgeKey = nudgeKey
        self.shownAt = shownAt
    }
}

enum SwiftDataSchema {
    static let models: [any PersistentModel.Type] = [
        SessionRecord.self,
        TopicAccuracy.self,
        PracticeStreakData.self,
        DifficultyNudgeRecord.self,
    ]
}
