import Foundation

struct TopicSession: Codable, Identifiable {
    var id: UUID
    var topicId: String
    var grade: String
    var date: Date
    var difficulty: String
    var totalQuestions: Int
    var correctAnswers: Int

    init(
        id: UUID = UUID(),
        topicId: String,
        grade: String,
        date: Date = .now,
        difficulty: String,
        totalQuestions: Int,
        correctAnswers: Int
    ) {
        self.id = id
        self.topicId = topicId
        self.grade = grade
        self.date = date
        self.difficulty = difficulty
        self.totalQuestions = totalQuestions
        self.correctAnswers = correctAnswers
    }
}

struct DailyStreak: Codable {
    var lastPracticedDate: Date
    var currentStreak: Int
    var longestStreak: Int

    init(lastPracticedDate: Date = .distantPast, currentStreak: Int = 0, longestStreak: Int = 0) {
        self.lastPracticedDate = lastPracticedDate
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
    }
}

struct ProgressSnapshot: Codable {
    var sessions: [TopicSession]
    var streak: DailyStreak

    static let empty = ProgressSnapshot(sessions: [], streak: DailyStreak())
}
