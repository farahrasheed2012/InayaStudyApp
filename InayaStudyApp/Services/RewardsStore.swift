import Foundation

struct BadgeRecord: Codable, Identifiable, Equatable {
    let topicId: String
    let earnedDate: Date
    let accuracy: Double
    let stars: Int

    var id: String { topicId }
}

@MainActor
final class RewardsStore: ObservableObject {
    @Published private(set) var badges: [BadgeRecord] = []

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = dir.appendingPathComponent("InayaStudyApp", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        fileURL = appDir.appendingPathComponent("badges.json")
        badges = Self.load(from: fileURL) ?? []
    }

    func hasBadge(for topicId: String) -> Bool {
        badges.contains { $0.topicId == topicId }
    }

    func badge(for topicId: String) -> BadgeRecord? {
        badges.first { $0.topicId == topicId }
    }

    @discardableResult
    func recordIfNewMasterBadge(topicId: String, stars: Int, accuracy: Double) -> Bool {
        guard stars >= 3, !hasBadge(for: topicId) else { return false }
        let record = BadgeRecord(topicId: topicId, earnedDate: .now, accuracy: accuracy, stars: stars)
        badges.append(record)
        save()
        return true
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(badges) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private static func load(from url: URL) -> [BadgeRecord]? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode([BadgeRecord].self, from: data)
    }

    func resetAll() {
        badges = []
        save()
    }
}
