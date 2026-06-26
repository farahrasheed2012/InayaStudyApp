import Foundation

/// Math POT 2 topics (T032–T059) mapped to dedicated POT2 topic entries for July catch-up week.
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
            competitionPot2Codes.contains(item.potCode) == false && item.potCode != "MIX"
        }.map(\.potCode))
    }

    static var competitionPot2Codes: Set<String> {
        Set(["T042", "T051", "T052", "T053", "T054"])
    }

    /// True when every T032–T059 code appears in the catch-up plan.
    static var includesAllPot2Topics: Bool {
        Set(allPot2Codes) == coveredPot2Codes
    }

    /// One POT2 code per dedicated topic (T032–T059).
    static let allItems: [Item] = [
        Item(potCode: "T032", topicId: "pot2-t032", day: 1),
        Item(potCode: "T033", topicId: "pot2-t033", day: 1),
        Item(potCode: "T034", topicId: "pot2-t034", day: 1),
        Item(potCode: "T035", topicId: "pot2-t035", day: 1),
        Item(potCode: "T036", topicId: "pot2-t036", day: 1),
        Item(potCode: "T037", topicId: "pot2-t037", day: 2),
        Item(potCode: "T038", topicId: "pot2-t038", day: 2),
        Item(potCode: "T039", topicId: "pot2-t039", day: 2),
        Item(potCode: "T040", topicId: "pot2-t040", day: 2),
        Item(potCode: "T049", topicId: "pot2-t049", day: 2),
        Item(potCode: "T041", topicId: "pot2-t041", day: 3),
        Item(potCode: "T043", topicId: "pot2-t043", day: 3),
        Item(potCode: "T044", topicId: "pot2-t044", day: 3),
        Item(potCode: "T042", topicId: "pot2-t042", day: 3),
        Item(potCode: "T045", topicId: "pot2-t045", day: 4),
        Item(potCode: "T046", topicId: "pot2-t046", day: 4),
        Item(potCode: "T047", topicId: "pot2-t047", day: 4),
        Item(potCode: "T048", topicId: "pot2-t048", day: 5),
        Item(potCode: "T050", topicId: "pot2-t050", day: 5),
        Item(potCode: "T058", topicId: "pot2-t058", day: 5),
        Item(potCode: "T051", topicId: "pot2-t051", day: 5),
        Item(potCode: "T052", topicId: "pot2-t052", day: 5),
        Item(potCode: "T053", topicId: "pot2-t053", day: 5),
        Item(potCode: "T054", topicId: "pot2-t054", day: 5),
        Item(potCode: "T055", topicId: "pot2-t055", day: 6),
        Item(potCode: "T056", topicId: "pot2-t056", day: 6),
        Item(potCode: "T057", topicId: "pot2-t057", day: 6),
        Item(potCode: "T059", topicId: "pot2-t059", day: 6),
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
        mathPOT2TopicIds
    }

    static var mathPOT2TopicIds: [String] {
        MathPOT2Topics.all.map(\.id)
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
        allItems
            .filter { $0.topicId == topicId }
            .map(\.potCode)
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
