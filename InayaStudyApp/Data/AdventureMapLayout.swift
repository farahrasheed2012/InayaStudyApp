import Foundation

struct MapWorld: Identifiable {
    let id: String
    let title: String
    let emoji: String
    let topicIds: [String]
}

struct AdventureMapRoute {
    let startTitle: String
    let startEmoji: String
    let endTitle: String
    let endEmoji: String
    let worlds: [MapWorld]
    let skyTop: String
    let skyBottom: String
    let hillColor: String

    var orderedTopicIds: [String] {
        worlds.flatMap(\.topicIds)
    }
}

enum AdventureMapLayout {
    static func route(subject: Subject, grade: GradeLevel) -> AdventureMapRoute {
        switch (subject, grade) {
        case (.math, .second): return mathSecond
        case (.math, .third): return mathThird
        case (.science, _): return scienceSecond
        default: return mathSecond
        }
    }

    private static let mathSecond = AdventureMapRoute(
        startTitle: "Inaya's Treehouse",
        startEmoji: "🏠",
        endTitle: "Star Summit",
        endEmoji: "⭐",
        worlds: [
            MapWorld(id: "number-kingdom", title: "Number Kingdom", emoji: "🔢", topicIds: ["place-value-1200", "compare-order"]),
            MapWorld(id: "addition-jungle", title: "Addition Jungle", emoji: "➕", topicIds: ["add-sub-1000", "skip-counting"]),
            MapWorld(id: "time-tower", title: "Time Tower", emoji: "🕐", topicIds: ["time-minutes", "money-coins"]),
            MapWorld(id: "fraction-forest", title: "Fraction Forest", emoji: "🍕", topicIds: ["fractions-basic", "even-odd"]),
            MapWorld(id: "measurement-mesa", title: "Measurement Mesa", emoji: "📏", topicIds: ["measurement-length"]),
        ],
        skyTop: "87CEEB",
        skyBottom: "E0F7FA",
        hillColor: "7CB342"
    )

    private static let mathThird = AdventureMapRoute(
        startTitle: "Math Base Camp",
        startEmoji: "🏕️",
        endTitle: "STAAR Summit",
        endEmoji: "🏆",
        worlds: [
            MapWorld(id: "multiply-meadow", title: "Multiplication Meadow", emoji: "✖️", topicIds: ["multiplication", "arrays-area-model"]),
            MapWorld(id: "division-valley", title: "Division Valley", emoji: "➗", topicIds: ["division"]),
            MapWorld(id: "fraction-falls", title: "Fraction Falls", emoji: "🌊", topicIds: ["fractions-number-line", "compare-fractions"]),
            MapWorld(id: "time-station", title: "Time Station", emoji: "⏱️", topicIds: ["elapsed-time"]),
            MapWorld(id: "shape-city", title: "Shape City", emoji: "📐", topicIds: ["perimeter-area", "data-graphs"]),
            MapWorld(id: "money-market", title: "Money Market", emoji: "💵", topicIds: ["money-word-problems", "staar-mixed"]),
        ],
        skyTop: "6C5CE7",
        skyBottom: "DFE6E9",
        hillColor: "00B894"
    )

    private static let scienceSecond = AdventureMapRoute(
        startTitle: "Lab Launchpad",
        startEmoji: "🔬",
        endTitle: "Discovery Peak",
        endEmoji: "🔭",
        worlds: [
            MapWorld(id: "tools-bay", title: "Tools Bay", emoji: "🧪", topicIds: ["sci-science-tools"]),
            MapWorld(id: "matter-mountain", title: "Matter Mountain", emoji: "🪨", topicIds: ["sci-matter-properties", "sci-matter-changes"]),
            MapWorld(id: "force-falls", title: "Force Falls", emoji: "💨", topicIds: ["sci-force-motion", "sci-energy-forms", "sci-sound-light"]),
            MapWorld(id: "earth-expedition", title: "Earth Expedition", emoji: "🌍", topicIds: ["sci-earth-materials", "sci-sky-patterns"]),
            MapWorld(id: "life-lagoon", title: "Life Lagoon", emoji: "🌿", topicIds: ["sci-plant-structures", "sci-life-cycles"]),
            MapWorld(id: "habitat-hills", title: "Habitat Hills", emoji: "🦁", topicIds: ["sci-animal-needs", "sci-habitats"]),
        ],
        skyTop: "FFB347",
        skyBottom: "FFF8E1",
        hillColor: "558B2F"
    )
}
