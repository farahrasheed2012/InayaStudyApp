import Foundation

enum StarChartLevel: Int, Comparable, CaseIterable {
    case hollow = 0
    case half = 1
    case full = 2
    case gold = 3

    static func < (lhs: StarChartLevel, rhs: StarChartLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var label: String {
        switch self {
        case .hollow: return "Not started"
        case .half: return "In progress"
        case .full: return "Mastered"
        case .gold: return "Perfect"
        }
    }

    var systemImage: String {
        switch self {
        case .hollow: return "star"
        case .half: return "star.leadinghalf.filled"
        case .full: return "star.fill"
        case .gold: return "star.circle.fill"
        }
    }
}

enum StarChartHelper {
    @MainActor
    static func level(for topic: Topic, progressStore: ProgressStore) -> StarChartLevel {
        let accuracy = progressStore.accuracy(for: topic.id)
        let best = progressStore.bestSessionAccuracy(for: topic.id)

        if best >= 1.0 { return .gold }
        if accuracy >= MapProgressHelper.unlockAccuracy { return .full }
        if accuracy > 0 { return .half }
        return .hollow
    }

    @MainActor
    static func summary(progressStore: ProgressStore, grade: GradeLevel, subject: Subject) -> (hollow: Int, half: Int, full: Int, gold: Int) {
        let topics = TopicRegistry.topics(for: grade, subject: subject)
        var counts = (0, 0, 0, 0)
        for topic in topics {
            switch level(for: topic, progressStore: progressStore) {
            case .hollow: counts.0 += 1
            case .half: counts.1 += 1
            case .full: counts.2 += 1
            case .gold: counts.3 += 1
            }
        }
        return counts
    }

    @MainActor
    static func totalLit(progressStore: ProgressStore) -> Int {
        var count = 0
        for subject in Subject.allCases {
            for grade in TopicRegistry.grades(for: subject) {
                let s = summary(progressStore: progressStore, grade: grade, subject: subject)
                count += s.half + s.full + s.gold
            }
        }
        return count
    }
}
