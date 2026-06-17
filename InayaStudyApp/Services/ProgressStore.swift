import Foundation

@MainActor
final class ProgressStore: ObservableObject {
    @Published private(set) var snapshot: ProgressSnapshot

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = dir.appendingPathComponent("InayaStudyApp", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        fileURL = appDir.appendingPathComponent("progress.json")
        snapshot = Self.load(from: fileURL) ?? .empty
    }

    func recordSession(topic: Topic, difficulty: Difficulty, total: Int, correct: Int) {
        let session = TopicSession(
            topicId: topic.id,
            grade: topic.grade.rawValue,
            difficulty: difficulty.rawValue,
            totalQuestions: total,
            correctAnswers: correct
        )
        snapshot.sessions.append(session)
        updateStreak()
        save()
    }

    func accuracy(for topicId: String) -> Double {
        let sessions = snapshot.sessions.filter { $0.topicId == topicId }
        guard !sessions.isEmpty else { return 0 }
        let total = sessions.reduce(0) { $0 + $1.totalQuestions }
        let correct = sessions.reduce(0) { $0 + $1.correctAnswers }
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }

    func totalProblemsSolved() -> Int {
        snapshot.sessions.reduce(0) { $0 + $1.totalQuestions }
    }

    func recentTopicIDs(limit: Int = 3) -> [String] {
        let sorted = snapshot.sessions.sorted { $0.date > $1.date }
        var seen = Set<String>()
        var result: [String] = []
        for s in sorted where !seen.contains(s.topicId) {
            seen.insert(s.topicId)
            result.append(s.topicId)
            if result.count >= limit { break }
        }
        return result
    }

    func streak() -> (current: Int, longest: Int) {
        (snapshot.streak.currentStreak, snapshot.streak.longestStreak)
    }

    func strongestAndWeakest(in topics: [Topic]) -> (strongest: Topic?, weakest: Topic?) {
        let withData = topics.map { ($0, accuracy(for: $0.id)) }.filter { $0.1 > 0 }
        guard !withData.isEmpty else { return (nil, nil) }
        let strongest = withData.max(by: { $0.1 < $1.1 })?.0
        let weakest = withData.min(by: { $0.1 < $1.1 })?.0
        return (strongest, weakest)
    }

    func resetAll() {
        snapshot = .empty
        save()
    }

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        var row = snapshot.streak
        let last = calendar.startOfDay(for: row.lastPracticedDate)
        if last == today {
            snapshot.streak = row
            return
        }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today) {
            if last == yesterday {
                row.currentStreak += 1
            } else if last < yesterday || last == .distantPast {
                row.currentStreak = 1
            }
        } else {
            row.currentStreak = 1
        }
        row.longestStreak = max(row.longestStreak, row.currentStreak)
        row.lastPracticedDate = .now
        snapshot.streak = row
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private static func load(from url: URL) -> ProgressSnapshot? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(ProgressSnapshot.self, from: data)
    }
}
