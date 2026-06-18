import Foundation

enum MapStopKind: Hashable {
    case start
    case topic(Topic)
    case end
}

struct MapStopItem: Identifiable, Hashable {
    let id: String
    let kind: MapStopKind
    let worldTitle: String?
    let worldEmoji: String?
}

enum MapStopStatus {
    case locked
    case current
    case completed
}

enum MapProgressHelper {
    static let unlockAccuracy = 0.6

    @MainActor
    static func stops(subject: Subject, grade: GradeLevel) -> [MapStopItem] {
        let route = AdventureMapLayout.route(subject: subject, grade: grade)
        var items: [MapStopItem] = [
            MapStopItem(id: "start", kind: .start, worldTitle: nil, worldEmoji: nil),
        ]

        for world in route.worlds {
            for topicId in world.topicIds {
                if let topic = TopicRegistry.topic(id: topicId) {
                    items.append(
                        MapStopItem(
                            id: topic.id,
                            kind: .topic(topic),
                            worldTitle: world.title,
                            worldEmoji: world.emoji
                        )
                    )
                }
            }
        }

        items.append(MapStopItem(id: "end", kind: .end, worldTitle: nil, worldEmoji: nil))
        return items
    }

    @MainActor
    static func topicStops(subject: Subject, grade: GradeLevel) -> [MapStopItem] {
        stops(subject: subject, grade: grade).filter {
            if case .topic = $0.kind { return true }
            return false
        }
    }

    @MainActor
    static func status(
        for stop: MapStopItem,
        at index: Int,
        allStops: [MapStopItem],
        progressStore: ProgressStore
    ) -> MapStopStatus {
        switch stop.kind {
        case .start, .end:
            return .completed
        case .topic(let topic):
            let topicStops = allStops.compactMap { item -> MapStopItem? in
                if case .topic = item.kind { return item }
                return nil
            }
            guard let topicIndex = topicStops.firstIndex(where: { $0.id == stop.id }) else {
                return .locked
            }

            let accuracy = progressStore.accuracy(for: topic.id)
            if accuracy >= unlockAccuracy {
                return .completed
            }

            if topicIndex == 0 {
                return .current
            }

            let previousId = topicStops[topicIndex - 1].id
            let previousAccuracy = progressStore.accuracy(for: previousId)
            if previousAccuracy >= unlockAccuracy {
                return .current
            }
            return .locked
        }
    }

    @MainActor
    static func currentTopicStop(
        subject: Subject,
        grade: GradeLevel,
        progressStore: ProgressStore
    ) -> MapStopItem? {
        let all = stops(subject: subject, grade: grade)
        return all.first { stop in
            status(for: stop, at: 0, allStops: all, progressStore: progressStore) == .current
        }
    }

    @MainActor
    static func bestStars(for topicId: String, progressStore: ProgressStore) -> Int {
        let best = progressStore.bestSessionAccuracy(for: topicId)
        return Encouragement.stars(for: best)
    }

    @MainActor
    static func sparkyShouldSleep(progressStore: ProgressStore) -> Bool {
        let last = progressStore.lastPracticedDate()
        if last == .distantPast { return true }
        let days = Calendar.current.dateComponents([.day], from: last, to: .now).day ?? 0
        return days >= 2
    }
}
