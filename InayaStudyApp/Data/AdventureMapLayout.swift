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
        case (.science, .second): return scienceSecond
        case (.science, .third): return scienceThird
        }
    }

    private static let mathSecond = AdventureMapRoute(
        startTitle: "Inaya's Treehouse",
        startEmoji: "🏠",
        endTitle: "Star Summit",
        endEmoji: "⭐",
        worlds: [
            MapWorld(id: "number-kingdom", title: "Number Kingdom", emoji: "🔢", topicIds: [
                "place-value-1200", "compose-decompose", "compare-order",
                "number-word-form", "more-or-less-100", "number-line-1200",
            ]),
            MapWorld(id: "addition-jungle", title: "Addition Jungle", emoji: "➕", topicIds: [
                "facts-to-100", "add-sub-1000", "word-problems-addsub-2", "skip-counting",
            ]),
            MapWorld(id: "fraction-forest", title: "Fraction Forest", emoji: "🍕", topicIds: ["fractions-basic", "fraction-models", "even-odd"]),
            MapWorld(id: "shape-studio", title: "Shape Studio", emoji: "🔷", topicIds: [
                "shapes-2d-3d", "arrays-groups-2", "equal-sharing-2", "area-square-units-2",
            ]),
            MapWorld(id: "graph-grove", title: "Graph Grove", emoji: "📊", topicIds: ["graphs-data-2"]),
            MapWorld(id: "time-tower", title: "Time Tower", emoji: "🕐", topicIds: [
                "time-minutes", "money-coins", "financial-literacy-2",
            ]),
            MapWorld(id: "measurement-mesa", title: "Measurement Mesa", emoji: "📏", topicIds: [
                "measurement-length", "measurement-metric-2", "measurement-wct",
            ]),
            MapWorld(id: "staar-summit-2", title: "STAAR Summit", emoji: "🏆", topicIds: ["staar-mixed-2"]),
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
            MapWorld(id: "place-value-peak", title: "Place Value Peak", emoji: "🏔️", topicIds: ["place-value-100k", "estimation-rounding"]),
            MapWorld(id: "add-sub-canyon", title: "Add/Sub Canyon", emoji: "🌉", topicIds: ["add-sub-1000-3", "two-step-word-problems"]),
            MapWorld(id: "multiply-meadow", title: "Multiplication Meadow", emoji: "✖️", topicIds: [
                "multiplication", "division", "even-odd-3", "arrays-area-model", "number-patterns-3",
            ]),
            MapWorld(id: "fraction-falls", title: "Fraction Falls", emoji: "🌊", topicIds: [
                "unit-fractions", "fractions-number-line", "equivalent-fractions", "compare-fractions",
            ]),
            MapWorld(id: "time-station", title: "Time Station", emoji: "⏱️", topicIds: ["elapsed-time"]),
            MapWorld(id: "shape-city", title: "Shape City", emoji: "📐", topicIds: [
                "shapes-quadrilaterals", "shapes-3d-3", "perimeter-area", "geo-measure-word-problems-3",
            ]),
            MapWorld(id: "measurement-market", title: "Measurement Market", emoji: "📏", topicIds: ["measurement-units-3"]),
            MapWorld(id: "data-graphs-plaza", title: "Data Plaza", emoji: "📊", topicIds: ["data-graphs"]),
            MapWorld(id: "money-market", title: "Money Market", emoji: "💵", topicIds: [
                "money-word-problems", "financial-literacy-3", "staar-mixed",
            ]),
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
            MapWorld(id: "tools-bay", title: "Tools Bay", emoji: "🧪", topicIds: [
                "sci-science-tools", "sci-scientific-method", "sci-scientists-work",
            ]),
            MapWorld(id: "matter-mountain", title: "Matter Mountain", emoji: "🪨", topicIds: ["sci-matter-properties", "sci-matter-changes", "sci-mixtures"]),
            MapWorld(id: "force-falls", title: "Force Falls", emoji: "💨", topicIds: [
                "sci-force-motion", "sci-energy-forms", "sci-vibration-sound", "sci-sound-light",
            ]),
            MapWorld(id: "earth-expedition", title: "Earth Expedition", emoji: "🌍", topicIds: [
                "sci-earth-materials", "sci-sky-patterns", "sci-weather-seasons",
                "sci-severe-weather", "sci-conservation",
            ]),
            MapWorld(id: "life-lagoon", title: "Life Lagoon", emoji: "🌿", topicIds: ["sci-plant-structures", "sci-life-cycles", "sci-food-chains"]),
            MapWorld(id: "habitat-hills", title: "Habitat Hills", emoji: "🦁", topicIds: ["sci-animal-needs", "sci-habitats"]),
            MapWorld(id: "science-summit-2", title: "Science Summit", emoji: "🏆", topicIds: ["sci2-mixed-review"]),
        ],
        skyTop: "FFB347",
        skyBottom: "FFF8E1",
        hillColor: "558B2F"
    )

    private static let scienceThird = AdventureMapRoute(
        startTitle: "Research Station",
        startEmoji: "🔬",
        endTitle: "Discovery Peak",
        endEmoji: "🌟",
        worlds: [
            MapWorld(id: "investigator-island", title: "Investigator Island", emoji: "🧪", topicIds: [
                "sci3-investigation", "sci3-science-practices",
            ]),
            MapWorld(id: "matter-lab", title: "Matter Lab", emoji: "💧", topicIds: ["sci3-matter-states"]),
            MapWorld(id: "force-field", title: "Force Field", emoji: "🧲", topicIds: [
                "sci3-force-magnets", "sci3-mechanical-energy",
                "sci3-everyday-energy", "sci3-energy-circuits",
            ]),
            MapWorld(id: "earth-watch", title: "Earth Watch", emoji: "🌎", topicIds: [
                "sci3-earth-soil", "sci3-conservation",
                "sci3-sun-moon", "sci3-weather-climate",
            ]),
            MapWorld(id: "living-world", title: "Living World", emoji: "🦋", topicIds: [
                "sci3-ecosystems", "sci3-fossils-changes",
                "sci3-growth-behavior", "sci3-inherited-traits", "sci3-life-cycles",
            ]),
            MapWorld(id: "science-summit", title: "Science Summit", emoji: "🏆", topicIds: ["sci3-mixed-review"]),
        ],
        skyTop: "48DBFB",
        skyBottom: "C7ECEE",
        hillColor: "1DD1A1"
    )
}
