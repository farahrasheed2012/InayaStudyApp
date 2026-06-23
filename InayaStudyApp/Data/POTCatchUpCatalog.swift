import Foundation

/// Math POT 2 topics (T032–T059) mapped to Inaya Study App topics for July catch-up week.
enum POTCatchUpCatalog {
    struct Item: Identifiable {
        let potCode: String
        let topicId: String
        let day: Int
        var id: String { "\(day)-\(potCode)-\(topicId)" }
    }

    struct DayPlan: Identifiable {
        let day: Int
        let title: String
        let items: [Item]
        var id: Int { day }
    }

    /// Every Math POT 2 code from the 2026 registration PDF (T032–T059).
    static let allPot2Codes: [String] = (32...59).map { String(format: "T%03d", $0) }

    static var coveredPot2Codes: Set<String> {
        Set(allItems.map(\.potCode).filter { $0 != "MIX" })
    }

    static var schoolPot2Codes: Set<String> {
        Set(allItems.filter { item in
            ["T042", "T051", "T052", "T053", "T054"].contains(item.potCode) == false
                && item.potCode != "MIX"
        }.map(\.potCode))
    }

    static var competitionPot2Codes: Set<String> {
        Set(["T042", "T051", "T052", "T053", "T054"])
    }

    /// True when every T032–T059 code appears in the catch-up plan.
    static var includesAllPot2Topics: Bool {
        Set(allPot2Codes) == coveredPot2Codes
    }

    /// All 28 POT 2 codes → app topic (existing or new `pot-*` topic).
    static let allItems: [Item] = [
        // Day 1 — Block 1: clocks, box diagrams, large add/sub, fact families
        Item(potCode: "T032", topicId: "time-minutes", day: 1),
        Item(potCode: "T033", topicId: "pot-box-diagrams-2", day: 1),
        Item(potCode: "T034", topicId: "add-sub-1000", day: 1),
        Item(potCode: "T035", topicId: "add-sub-1000", day: 1),
        Item(potCode: "T036", topicId: "pot-fact-families-2", day: 1),
        // Day 2 — Block 2: place value & rounding
        Item(potCode: "T037", topicId: "place-value-1200", day: 2),
        Item(potCode: "T038", topicId: "compare-order", day: 2),
        Item(potCode: "T039", topicId: "compose-decompose", day: 2),
        Item(potCode: "T040", topicId: "number-word-form", day: 2),
        Item(potCode: "T049", topicId: "pot-rounding-2", day: 2),
        // Day 3 — Block 3: time word problems, 3-number add, 3D solids
        Item(potCode: "T041", topicId: "pot-time-word-problems-2", day: 3),
        Item(potCode: "T043", topicId: "pot-add-three-numbers-2", day: 3),
        Item(potCode: "T044", topicId: "pot-solid-geometry-2", day: 3),
        Item(potCode: "T042", topicId: "pot-logic-reasoning-2", day: 3),
        // Day 4 — Block 4a: graphs, money, fractions
        Item(potCode: "T045", topicId: "graphs-data-2", day: 4),
        Item(potCode: "T046", topicId: "pot-coin-word-problems-2", day: 4),
        Item(potCode: "T047", topicId: "pot-fraction-of-set-2", day: 4),
        // Day 5 — Block 4b: line graphs & Venn
        Item(potCode: "T048", topicId: "pot-line-graphs-2", day: 5),
        Item(potCode: "T050", topicId: "pot-venn-diagrams-2", day: 5),
        Item(potCode: "T058", topicId: "pot-venn-diagrams-2", day: 5),
        Item(potCode: "T051", topicId: "pot-logic-reasoning-2", day: 5),
        Item(potCode: "T052", topicId: "pot-venn-diagrams-2", day: 5),
        Item(potCode: "T053", topicId: "pot-logic-reasoning-2", day: 5),
        Item(potCode: "T054", topicId: "pot-logic-reasoning-2", day: 5),
        // Day 6 — Block 5: logic & multiplication
        Item(potCode: "T055", topicId: "pot-logic-reasoning-2", day: 6),
        Item(potCode: "T056", topicId: "pot-logic-reasoning-2", day: 6),
        Item(potCode: "T057", topicId: "arrays-groups-2", day: 6),
        Item(potCode: "T059", topicId: "pot-multiply-multidigit-2", day: 6),
        // Day 7 — full mixed review
        Item(potCode: "MIX", topicId: "pot-mixed-catchup-2", day: 7),
    ]

    static let dayPlans: [DayPlan] = {
        (1...7).map { day in
            let items = allItems.filter { $0.day == day }
            return DayPlan(day: day, title: dayTitle(day), items: items)
        }
    }()

    /// POT 1 skills referenced as prerequisites — covered in the regular Adventure map, not this week.
    static let pot1PrerequisiteCodes: [String] = [
        "T004", "T005", "T006", "T011", "T016", "T018", "T024", "T025", "T026", "T030",
    ]

    /// Unique practice topics in the catch-up path (excludes mixed review).
    static var uniqueTopicIds: [String] {
        var seen = Set<String>()
        return allItems.map(\.topicId).filter { seen.insert($0).inserted }
    }

    static func topics(forDay day: Int) -> [Topic] {
        let ids = allItems.filter { $0.day == day }.map(\.topicId)
        var seen = Set<String>()
        return ids.compactMap { id -> Topic? in
            guard seen.insert(id).inserted else { return nil }
            return TopicRegistry.topic(id: id)
        }
    }

    static func potCodes(forTopicId topicId: String) -> [String] {
        var seen = Set<String>()
        return allItems
            .filter { $0.topicId == topicId }
            .map(\.potCode)
            .filter { seen.insert($0).inserted }
    }

    private static func dayTitle(_ day: Int) -> String {
        switch day {
        case 1: return "Day 1 · Clocks & large numbers"
        case 2: return "Day 2 · Place value & rounding"
        case 3: return "Day 3 · Time, 3-number add & shapes"
        case 4: return "Day 4 · Graphs, money & fractions"
        case 5: return "Day 5 · Line graphs & Venn"
        case 6: return "Day 6 · Logic & multiplication"
        case 7: return "Day 7 · Mixed review"
        default: return "Day \(day)"
        }
    }
}
