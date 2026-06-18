import Foundation

enum GameContent {
    // MARK: - Math

    static func mathProblem(grade: Grade) -> (prompt: String, answer: Int) {
        switch grade {
        case .second:
            let a = Int.random(in: 1...50)
            let b = Int.random(in: 1...50)
            if Bool.random() {
                return ("\(a) + \(b)", a + b)
            }
            let hi = max(a, b)
            let lo = min(a, b)
            return ("\(hi) − \(lo)", hi - lo)
        case .third:
            if Bool.random() {
                let a = Int.random(in: 2...10)
                let b = Int.random(in: 2...10)
                return ("\(a) × \(b)", a * b)
            }
            let b = Int.random(in: 2...10)
            let answer = Int.random(in: 2...10)
            return ("\(answer * b) ÷ \(b)", answer)
        }
    }

    static func mathDistractors(correct: Int, grade: Grade) -> [Int] {
        var set = Set<Int>()
        set.insert(correct)
        while set.count < 4 {
            let delta = Int.random(in: -12...12)
            let candidate = max(0, correct + delta)
            if candidate != correct { set.insert(candidate) }
        }
        return Array(set).shuffled()
    }

    static func coinTargetCents(grade: Grade) -> Int {
        switch grade {
        case .second:
            return [7, 13, 25, 36, 47, 58, 67, 74, 83, 99].randomElement()!
        case .third:
            return [125, 187, 234, 299, 350, 412, 475, 523, 599, 475].randomElement()!
        }
    }

    static func fractionPrompt(grade: Grade) -> (numerator: Int, denominator: Int) {
        switch grade {
        case .second:
            let denom = [2, 4].randomElement()!
            return (Int.random(in: 1..<denom), denom)
        case .third:
            let denom = [2, 3, 4, 6, 8].randomElement()!
            return (Int.random(in: 1..<denom), denom)
        }
    }

    static func bingoProducts(grade: Grade) -> [Int] {
        let range = grade == .second ? 1...5 : 1...10
        var products = Set<Int>()
        while products.count < 16 {
            let a = Int.random(in: range)
            let b = Int.random(in: range)
            products.insert(a * b)
        }
        return Array(products)
    }

    static func bingoCall(grade: Grade) -> (a: Int, b: Int, product: Int) {
        let range = grade == .second ? 1...5 : 1...10
        let a = Int.random(in: range)
        let b = Int.random(in: range)
        return (a, b, a * b)
    }

    static func numberLineJump(grade: Grade) -> (start: Int, delta: Int, answer: Int) {
        switch grade {
        case .second:
            let jumps = [1, 2, 5, 10]
            let start = Int.random(in: 0...80)
            let jump = jumps.randomElement()!
            if Bool.random() {
                return (start, jump, min(100, start + jump))
            }
            return (start, -jump, max(0, start - jump))
        case .third:
            let jumps = [10, 25, 50, 100]
            let start = Int.random(in: 0...900)
            let jump = jumps.randomElement()!
            if Bool.random() {
                return (start, jump, min(1000, start + jump))
            }
            return (start, -jump, max(-50, start - jump))
        }
    }

    // MARK: - Science sort categories

    struct SortCategory: Identifiable, Hashable {
        let id: String
        let title: String
        let colorHex: String
    }

    struct SortCard: Identifiable {
        let id = UUID()
        let label: String
        let categoryID: String
    }

    static func sortRound(grade: Grade) -> (categories: [SortCategory], cards: [SortCard]) {
        let sets = grade == .second ? secondSortSets : thirdSortSets
        let pick = sets.randomElement()!
        let cards = pick.items.shuffled().map { SortCard(label: $0.0, categoryID: $0.1) }
        return (pick.categories, cards)
    }

    private static let secondSortSets: [(grade: Grade, categories: [SortCategory], items: [(String, String)])] = [
        (
            .second,
            [
                SortCategory(id: "living", title: "Living", colorHex: "2ECC71"),
                SortCategory(id: "nonliving", title: "Nonliving", colorHex: "95A5A6"),
            ],
            [
                ("Tree", "living"), ("Rock", "nonliving"), ("Dog", "living"), ("Cloud", "nonliving"),
                ("Flower", "living"), ("Chair", "nonliving"), ("Fish", "living"), ("Pencil", "nonliving"),
                ("Butterfly", "living"), ("Book", "nonliving"), ("Grass", "living"), ("Toy car", "nonliving"),
                ("Bird", "living"), ("Sand", "nonliving"), ("Worm", "living"),
            ]
        ),
        (
            .second,
            [
                SortCategory(id: "solid", title: "Solid", colorHex: "3498DB"),
                SortCategory(id: "liquid", title: "Liquid", colorHex: "1ABC9C"),
                SortCategory(id: "gas", title: "Gas", colorHex: "9B59B6"),
            ],
            [
                ("Ice", "solid"), ("Water", "liquid"), ("Steam", "gas"), ("Rock", "solid"),
                ("Juice", "liquid"), ("Air", "gas"), ("Wood", "solid"), ("Milk", "liquid"),
                ("Oxygen", "gas"), ("Metal", "solid"), ("Oil", "liquid"), ("Helium", "gas"),
                ("Sand", "solid"), ("Rain", "liquid"), ("Smoke", "gas"),
            ]
        ),
    ]

    private static let thirdSortSets: [(grade: Grade, categories: [SortCategory], items: [(String, String)])] = [
        (
            .third,
            [
                SortCategory(id: "producer", title: "Producer", colorHex: "27AE60"),
                SortCategory(id: "consumer", title: "Consumer", colorHex: "E67E22"),
                SortCategory(id: "decomposer", title: "Decomposer", colorHex: "8E44AD"),
            ],
            [
                ("Grass", "producer"), ("Rabbit", "consumer"), ("Mushroom", "decomposer"),
                ("Sunflower", "producer"), ("Hawk", "consumer"), ("Bacteria", "decomposer"),
                ("Algae", "producer"), ("Deer", "consumer"), ("Worm", "decomposer"),
                ("Tree", "producer"), ("Snake", "consumer"), ("Fungi", "decomposer"),
                ("Corn", "producer"), ("Fox", "consumer"), ("Beetle", "decomposer"),
            ]
        ),
        (
            .third,
            [
                SortCategory(id: "push", title: "Push", colorHex: "E74C3C"),
                SortCategory(id: "pull", title: "Pull", colorHex: "3498DB"),
            ],
            [
                ("Kicking a ball", "push"), ("Opening a door", "pull"), ("Pushing a swing", "push"),
                ("Tugging rope", "pull"), ("Closing a drawer", "push"), ("Lifting a bag", "pull"),
                ("Hitting a drum", "push"), ("Pulling a wagon", "pull"), ("Shoving a box", "push"),
                ("Opening curtains", "pull"), ("Pressing elevator button", "push"), ("Pulling a sled", "pull"),
                ("Throwing", "push"), ("Magnet attracting", "pull"), ("Stopping a bike", "push"),
            ]
        ),
    ]

    // MARK: - Food web

    struct FoodOrganism: Identifiable, Hashable {
        let id: String
        let label: String
        let emoji: String
    }

    struct FoodEdge: Hashable {
        let from: String
        let to: String
    }

    static func foodWebEcosystem(grade: Grade, index: Int) -> (name: String, organisms: [FoodOrganism], edges: [FoodEdge]) {
        let ecosystems = grade == .second ? secondFoodChains : thirdFoodWebs
        return ecosystems[index % ecosystems.count]
    }

    private static let secondFoodChains: [(String, [FoodOrganism], [FoodEdge])] = [
        (
            "Meadow",
            [
                FoodOrganism(id: "sun", label: "Sun", emoji: "☀️"),
                FoodOrganism(id: "grass", label: "Grass", emoji: "🌿"),
                FoodOrganism(id: "rabbit", label: "Rabbit", emoji: "🐰"),
            ],
            [FoodEdge(from: "sun", to: "grass"), FoodEdge(from: "grass", to: "rabbit")]
        ),
        (
            "Pond",
            [
                FoodOrganism(id: "sun", label: "Sun", emoji: "☀️"),
                FoodOrganism(id: "algae", label: "Algae", emoji: "🟢"),
                FoodOrganism(id: "fish", label: "Fish", emoji: "🐟"),
            ],
            [FoodEdge(from: "sun", to: "algae"), FoodEdge(from: "algae", to: "fish")]
        ),
        (
            "Forest",
            [
                FoodOrganism(id: "sun", label: "Sun", emoji: "☀️"),
                FoodOrganism(id: "leaves", label: "Leaves", emoji: "🍃"),
                FoodOrganism(id: "caterpillar", label: "Caterpillar", emoji: "🐛"),
            ],
            [FoodEdge(from: "sun", to: "leaves"), FoodEdge(from: "leaves", to: "caterpillar")]
        ),
    ]

    private static let thirdFoodWebs: [(String, [FoodOrganism], [FoodEdge])] = [
        (
            "Meadow",
            [
                FoodOrganism(id: "sun", label: "Sun", emoji: "☀️"),
                FoodOrganism(id: "grass", label: "Grass", emoji: "🌿"),
                FoodOrganism(id: "grasshopper", label: "Grasshopper", emoji: "🦗"),
                FoodOrganism(id: "frog", label: "Frog", emoji: "🐸"),
                FoodOrganism(id: "hawk", label: "Hawk", emoji: "🦅"),
            ],
            [
                FoodEdge(from: "sun", to: "grass"),
                FoodEdge(from: "grass", to: "grasshopper"),
                FoodEdge(from: "grasshopper", to: "frog"),
                FoodEdge(from: "frog", to: "hawk"),
            ]
        ),
        (
            "Pond",
            [
                FoodOrganism(id: "sun", label: "Sun", emoji: "☀️"),
                FoodOrganism(id: "algae", label: "Algae", emoji: "🟢"),
                FoodOrganism(id: "minnow", label: "Minnow", emoji: "🐟"),
                FoodOrganism(id: "heron", label: "Heron", emoji: "🦩"),
                FoodOrganism(id: "bacteria", label: "Bacteria", emoji: "🦠"),
            ],
            [
                FoodEdge(from: "sun", to: "algae"),
                FoodEdge(from: "algae", to: "minnow"),
                FoodEdge(from: "minnow", to: "heron"),
                FoodEdge(from: "heron", to: "bacteria"),
            ]
        ),
        (
            "Forest",
            [
                FoodOrganism(id: "sun", label: "Sun", emoji: "☀️"),
                FoodOrganism(id: "oak", label: "Oak tree", emoji: "🌳"),
                FoodOrganism(id: "squirrel", label: "Squirrel", emoji: "🐿️"),
                FoodOrganism(id: "snake", label: "Snake", emoji: "🐍"),
                FoodOrganism(id: "owl", label: "Owl", emoji: "🦉"),
            ],
            [
                FoodEdge(from: "sun", to: "oak"),
                FoodEdge(from: "oak", to: "squirrel"),
                FoodEdge(from: "squirrel", to: "snake"),
                FoodEdge(from: "snake", to: "owl"),
            ]
        ),
    ]

    // MARK: - Weather

    enum WeatherRoundKind { case dress, tool, condition }

    static func weatherRound(grade: Grade) -> (kind: WeatherRoundKind, scene: String, prompt: String, choices: [String], correct: String) {
        let kind: WeatherRoundKind = [.dress, .tool, .condition].randomElement()!
        switch kind {
        case .dress:
            let scene = ["Arctic", "Rainforest", "Desert", "Snowy day"].randomElement()!
            let correct: String
            let choices: [String]
            switch scene {
            case "Arctic": correct = "Coat"; choices = ["Coat", "Shorts", "Sandals", "Tank top"]
            case "Rainforest": correct = "Rain boots"; choices = ["Rain boots", "Snow pants", "Winter hat", "Gloves"]
            case "Desert": correct = "Sun hat"; choices = ["Sun hat", "Raincoat", "Boots", "Scarf"]
            default: correct = "Winter coat"; choices = ["Winter coat", "Swimsuit", "Flip flops", "Sunglasses only"]
            }
            return (.dress, scene, "Dress for \(scene.lowercased())", choices, correct)
        case .tool:
            if grade == .second {
                let pairs = [
                    ("How hot is it?", "Thermometer", ["Thermometer", "Rain gauge", "Wind vane", "Barometer"]),
                    ("How much rain fell?", "Rain gauge", ["Rain gauge", "Thermometer", "Wind vane", "Barometer"]),
                ]
                let p = pairs.randomElement()!
                return (.tool, "Weather lab", p.0, p.2, p.1)
            }
            let pairs = [
                ("How hot is it?", "Thermometer"),
                ("How much rain?", "Rain gauge"),
                ("Which way is wind blowing?", "Wind vane"),
                ("Air pressure?", "Barometer"),
            ]
            let p = pairs.randomElement()!
            let all = ["Thermometer", "Rain gauge", "Wind vane", "Barometer"]
            return (.tool, "Weather lab", p.0, all.shuffled(), p.1)
        case .condition:
            let pairs = [
                ("Gray puffy clouds often bring rain.", "Rainy"),
                ("Bright sun and few clouds.", "Sunny"),
                ("Very cold with ice crystals falling.", "Snowy"),
                ("Strong moving air.", "Windy"),
            ]
            let p = pairs.randomElement()!
            let all = ["Rainy", "Sunny", "Snowy", "Windy"]
            return (.condition, "Sky watch", p.0, all.shuffled(), p.1)
        }
    }

    // MARK: - Quiz show / daily / boss

    static func quizShowCategories(grade: Grade) -> [String] {
        grade == .second
            ? ["Addition", "Subtraction", "Living Things", "Weather"]
            : ["Multiplication", "Fractions", "Ecosystems", "Force & Motion"]
    }

    static func quizShowQuestion(category: String, grade: Grade, points: Int) -> (question: String, choices: [String], correct: String) {
        switch category {
        case "Addition", "Multiplication":
            if grade == .second {
                let a = Int.random(in: 1...20)
                let b = Int.random(in: 1...20)
                let ans = a + b
                return ("\(a) + \(b) = ?", numericChoices(correct: ans), "\(ans)")
            }
            let a = Int.random(in: 2...9)
            let b = Int.random(in: 2...9)
            let ans = a * b
            return ("\(a) × \(b) = ?", numericChoices(correct: ans), "\(ans)")
        case "Subtraction", "Fractions":
            if grade == .second {
                let a = Int.random(in: 10...50)
                let b = Int.random(in: 1...9)
                return ("\(a) − \(b) = ?", numericChoices(correct: a - b), "\(a - b)")
            }
            return ("Which fraction is one half?", ["1/2", "1/4", "3/4", "2/3"], "1/2")
        case "Living Things", "Ecosystems":
            return (
                grade == .second ? "A tree is ___." : "Grass is a ___.",
                grade == .second ? ["Living", "Nonliving", "Liquid", "Gas"] : ["Producer", "Consumer", "Decomposer", "Rock"],
                grade == .second ? "Living" : "Producer"
            )
        default:
            return (
                "What tool measures temperature?",
                ["Thermometer", "Ruler", "Scale", "Clock"],
                "Thermometer"
            )
        }
    }

    static func dailyChallengeQuestion(grade: Grade) -> (question: String, choices: [String], correct: String) {
        if Bool.random() {
            let (prompt, answer) = mathProblem(grade: grade)
            return (prompt + " = ?", numericChoices(correct: answer), "\(answer)")
        }
        let q = quizShowQuestion(
            category: grade == .second ? "Living Things" : "Ecosystems",
            grade: grade,
            points: 100
        )
        return (q.question, q.choices, q.correct)
    }

    static func bossQuestion(grade: Grade, index: Int) -> (question: String, choices: [String], correct: String) {
        let cats = quizShowCategories(grade: grade)
        let cat = cats[index % cats.count]
        let q = quizShowQuestion(category: cat, grade: grade, points: 400)
        return (q.question, q.choices, q.correct)
    }

    private static func numericChoices(correct: Int) -> [String] {
        var vals = Set([correct])
        while vals.count < 4 {
            vals.insert(correct + Int.random(in: -8...8))
        }
        return vals.map(String.init).shuffled()
    }

    // MARK: - Tier 1 games

    struct PatternRound {
        let sequence: [Int]
        let missingIndex: Int
        let correct: Int
        let choices: [Int]
        var displaySequence: [String] {
            sequence.enumerated().map { index, value in
                index == missingIndex ? "?" : "\(value)"
            }
        }
    }

    static func patternRound(grade: Grade, round: Int) -> PatternRound {
        switch grade {
        case .second:
            let step = [2, 5, 10].randomElement()!
            let start = Int.random(in: 0...20)
            var seq = (0..<5).map { start + step * $0 }
            let missing = Int.random(in: 1..<4)
            let correct = seq[missing]
            let choices = mathDistractors(correct: correct, grade: grade)
            return PatternRound(sequence: seq, missingIndex: missing, correct: correct, choices: choices)
        case .third:
            if round % 2 == 0 {
                let factor = Int.random(in: 2...5)
                let start = Int.random(in: 2...6)
                var seq = (0..<5).map { start * Int(pow(Double(factor), Double($0))) }
                let missing = Int.random(in: 1..<4)
                let correct = seq[missing]
                return PatternRound(sequence: seq, missingIndex: missing, correct: correct, choices: mathDistractors(correct: correct, grade: grade))
            }
            let start = Int.random(in: 1...8)
            var seq = (0..<5).map { start + $0 * $0 }
            let missing = Int.random(in: 1..<4)
            let correct = seq[missing]
            return PatternRound(sequence: seq, missingIndex: missing, correct: correct, choices: mathDistractors(correct: correct, grade: grade))
        }
    }

    struct HabitatPair: Identifiable, Hashable {
        let id = UUID()
        let animal: String
        let emoji: String
        let habitat: String
        let habitatEmoji: String
    }

    static func habitatRound(grade: Grade) -> [HabitatPair] {
        let pool = grade == .second ? secondHabitats : thirdHabitats
        return Array(pool.shuffled().prefix(4))
    }

    private static let secondHabitats: [HabitatPair] = [
        HabitatPair(animal: "Polar bear", emoji: "🐻‍❄️", habitat: "Arctic", habitatEmoji: "❄️"),
        HabitatPair(animal: "Camel", emoji: "🐫", habitat: "Desert", habitatEmoji: "🏜️"),
        HabitatPair(animal: "Frog", emoji: "🐸", habitat: "Pond", habitatEmoji: "💧"),
        HabitatPair(animal: "Monkey", emoji: "🐒", habitat: "Rainforest", habitatEmoji: "🌴"),
        HabitatPair(animal: "Penguin", emoji: "🐧", habitat: "Antarctica", habitatEmoji: "🧊"),
        HabitatPair(animal: "Fish", emoji: "🐟", habitat: "Ocean", habitatEmoji: "🌊"),
        HabitatPair(animal: "Deer", emoji: "🦌", habitat: "Forest", habitatEmoji: "🌲"),
        HabitatPair(animal: "Crab", emoji: "🦀", habitat: "Beach", habitatEmoji: "🏖️"),
    ]

    private static let thirdHabitats: [HabitatPair] = [
        HabitatPair(animal: "Eagle", emoji: "🦅", habitat: "Mountains", habitatEmoji: "⛰️"),
        HabitatPair(animal: "Salmon", emoji: "🐟", habitat: "River", habitatEmoji: "🏞️"),
        HabitatPair(animal: "Cactus wren", emoji: "🐦", habitat: "Desert", habitatEmoji: "🌵"),
        HabitatPair(animal: "Otter", emoji: "🦦", habitat: "River", habitatEmoji: "💧"),
        HabitatPair(animal: "Wolf", emoji: "🐺", habitat: "Forest", habitatEmoji: "🌲"),
        HabitatPair(animal: "Jellyfish", emoji: "🪼", habitat: "Ocean", habitatEmoji: "🌊"),
        HabitatPair(animal: "Butterfly", emoji: "🦋", habitat: "Meadow", habitatEmoji: "🌼"),
        HabitatPair(animal: "Bat", emoji: "🦇", habitat: "Cave", habitatEmoji: "🪨"),
    ]

    struct RescueScenario {
        let animal: String
        let emoji: String
        let question: String
        let correctHabitat: String
        let wrongHabitats: [String]
        let funnyWrong: [String: String]
    }

    static func rescueScenario(grade: Grade, index: Int) -> RescueScenario {
        let scenarios = grade == .second ? secondRescue : thirdRescue
        return scenarios[index % scenarios.count]
    }

    private static let secondRescue: [RescueScenario] = [
        RescueScenario(
            animal: "Polar bear cub", emoji: "🐻‍❄️",
            question: "Where does this animal live?",
            correctHabitat: "Arctic ice",
            wrongHabitats: ["Hot desert", "Rainforest", "Pond"],
            funnyWrong: ["Hot desert": "Brr, too hot! The cub needs ice.", "Rainforest": "Too wet and leafy!", "Pond": "Bears don't live in ponds!"]
        ),
        RescueScenario(
            animal: "Baby frog", emoji: "🐸",
            question: "What habitat does a frog need?",
            correctHabitat: "Pond",
            wrongHabitats: ["Desert", "Arctic", "Cave"],
            funnyWrong: ["Desert": "Frogs need water to hop!", "Arctic": "Too cold for tadpoles!", "Cave": "Frogs love sunshine near water!"]
        ),
        RescueScenario(
            animal: "Lost puppy fish", emoji: "🐟",
            question: "Where should this fish swim home?",
            correctHabitat: "Ocean",
            wrongHabitats: ["Forest", "Desert", "Sky"],
            funnyWrong: ["Forest": "Fish can't climb trees!", "Desert": "No water here!", "Sky": "Only birds fly up there!"]
        ),
        RescueScenario(
            animal: "Baby deer", emoji: "🦌",
            question: "Where do deer find food and shelter?",
            correctHabitat: "Forest",
            wrongHabitats: ["Ocean", "Arctic ice", "Beach sand"],
            funnyWrong: ["Ocean": "Deer can't swim that far!", "Arctic ice": "Too cold for fawns!", "Beach sand": "Not enough trees!"]
        ),
    ]

    private static let thirdRescue: [RescueScenario] = [
        RescueScenario(
            animal: "Lost sea turtle", emoji: "🐢",
            question: "Where does this turtle belong?",
            correctHabitat: "Ocean",
            wrongHabitats: ["Desert", "Mountain peak", "City street"],
            funnyWrong: ["Desert": "Turtles need the sea!", "Mountain peak": "Too rocky to swim!", "City street": "Cars aren't friends!"]
        ),
        RescueScenario(
            animal: "Baby owl", emoji: "🦉",
            question: "What habitat helps owls hunt at night?",
            correctHabitat: "Forest",
            wrongHabitats: ["Ocean", "Pond", "Desert"],
            funnyWrong: ["Ocean": "Owls don't dive for fish!", "Pond": "Too splashy!", "Desert": "Owls need trees to perch!"]
        ),
        RescueScenario(
            animal: "Stranded bat", emoji: "🦇",
            question: "Where do bats roost safely?",
            correctHabitat: "Cave",
            wrongHabitats: ["Open meadow", "Ocean", "Arctic"],
            funnyWrong: ["Open meadow": "Bats need dark caves!", "Ocean": "Bats can't swim!", "Arctic": "Too bright and cold!"]
        ),
    ]
}
