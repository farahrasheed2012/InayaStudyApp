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

@Model
final class GameSession {
    var gameID: String
    var gradeRaw: String
    var subjectRaw: String
    var score: Int
    var totalRounds: Int
    var durationSeconds: Int
    var playedAt: Date

    init(
        gameID: String,
        grade: GradeLevel,
        subject: Subject,
        score: Int,
        totalRounds: Int,
        durationSeconds: Int,
        playedAt: Date = .now
    ) {
        self.gameID = gameID
        self.gradeRaw = grade.rawValue
        self.subjectRaw = subject.rawValue
        self.score = score
        self.totalRounds = totalRounds
        self.durationSeconds = durationSeconds
        self.playedAt = playedAt
    }

    var grade: GradeLevel { GradeLevel(rawValue: gradeRaw) ?? .second }
    var subject: Subject { Subject(rawValue: subjectRaw) ?? .math }
}

@Model
final class GameBadge {
    @Attribute(.unique) var badgeKey: String
    var gameID: String
    var gradeRaw: String
    var earnedAt: Date
    var label: String
    var symbolName: String

    init(
        badgeKey: String,
        gameID: String,
        grade: GradeLevel,
        earnedAt: Date = .now,
        label: String,
        symbolName: String
    ) {
        self.badgeKey = badgeKey
        self.gameID = gameID
        self.gradeRaw = grade.rawValue
        self.earnedAt = earnedAt
        self.label = label
        self.symbolName = symbolName
    }

    var grade: GradeLevel { GradeLevel(rawValue: gradeRaw) ?? .second }
}

@Model
final class DailyChallengeStreak {
    @Attribute(.unique) var key: String
    var lastCompletedDate: Date
    var currentStreak: Int
    var longestStreak: Int

    init(
        key: String = "daily",
        lastCompletedDate: Date = .distantPast,
        currentStreak: Int = 0,
        longestStreak: Int = 0
    ) {
        self.key = key
        self.lastCompletedDate = lastCompletedDate
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
    }
}

@Model
final class BossBattleState {
    @Attribute(.unique) var key: String
    var sessionsSinceBoss: Int
    var lastDefeatAt: Date
    var lastAttemptAt: Date

    init(
        key: String = "main",
        sessionsSinceBoss: Int = 0,
        lastDefeatAt: Date = .distantPast,
        lastAttemptAt: Date = .distantPast
    ) {
        self.key = key
        self.sessionsSinceBoss = sessionsSinceBoss
        self.lastDefeatAt = lastDefeatAt
        self.lastAttemptAt = lastAttemptAt
    }
}

@Model
final class CollectedCreature {
    @Attribute(.unique) var creatureKey: String
    var creatureID: String
    var gameID: String
    var gradeRaw: String
    var name: String
    var emoji: String
    var funFact: String
    var unlockedAt: Date

    init(
        creatureKey: String,
        creatureID: String,
        gameID: String,
        grade: GradeLevel,
        name: String,
        emoji: String,
        funFact: String,
        unlockedAt: Date = .now
    ) {
        self.creatureKey = creatureKey
        self.creatureID = creatureID
        self.gameID = gameID
        self.gradeRaw = grade.rawValue
        self.name = name
        self.emoji = emoji
        self.funFact = funFact
        self.unlockedAt = unlockedAt
    }

    var grade: GradeLevel { GradeLevel(rawValue: gradeRaw) ?? .second }
}

enum SwiftDataSchema {
    static let models: [any PersistentModel.Type] = [
        SessionRecord.self,
        TopicAccuracy.self,
        PracticeStreakData.self,
        DifficultyNudgeRecord.self,
        GameSession.self,
        GameBadge.self,
        DailyChallengeStreak.self,
        BossBattleState.self,
        CollectedCreature.self,
    ]
}
