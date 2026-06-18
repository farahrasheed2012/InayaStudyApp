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

    // MARK: - Tier 2 games

    struct ShadowRound {
        let silhouette: String
        let prompt: String
        let correct: String
        let choices: [String]
    }

    static func shadowRound(grade: Grade, round: Int) -> ShadowRound {
        let pool = grade == .second ? secondShadowRounds : thirdShadowRounds
        return pool[(round - 1) % pool.count]
    }

    private static let secondShadowRounds: [ShadowRound] = [
        ShadowRound(silhouette: "🌳", prompt: "What plant is this?", correct: "Oak tree", choices: ["Oak tree", "Cactus", "Seaweed", "Moss"]),
        ShadowRound(silhouette: "🦋", prompt: "Whose shadow?", correct: "Butterfly", choices: ["Butterfly", "Bird", "Bee", "Dragonfly"]),
        ShadowRound(silhouette: "🌻", prompt: "Name this plant part", correct: "Flower", choices: ["Flower", "Root", "Stem", "Leaf"]),
        ShadowRound(silhouette: "🐸", prompt: "Which animal?", correct: "Frog", choices: ["Frog", "Fish", "Turtle", "Lizard"]),
        ShadowRound(silhouette: "🍎", prompt: "What grows on trees?", correct: "Apple", choices: ["Apple", "Carrot", "Potato", "Corn"]),
        ShadowRound(silhouette: "🐛", prompt: "Life cycle stage?", correct: "Caterpillar", choices: ["Caterpillar", "Egg", "Adult butterfly", "Seed"]),
        ShadowRound(silhouette: "🌵", prompt: "Desert plant?", correct: "Cactus", choices: ["Cactus", "Fern", "Moss", "Algae"]),
        ShadowRound(silhouette: "🐟", prompt: "Lives in water?", correct: "Fish", choices: ["Fish", "Robin", "Rabbit", "Snake"]),
    ]

    private static let thirdShadowRounds: [ShadowRound] = [
        ShadowRound(silhouette: "🦆", prompt: "Webbed feet help swim — who?", correct: "Duck", choices: ["Duck", "Owl", "Hawk", "Eagle"]),
        ShadowRound(silhouette: "🐪", prompt: "Stores water in desert?", correct: "Camel", choices: ["Camel", "Penguin", "Frog", "Salmon"]),
        ShadowRound(silhouette: "🦎", prompt: "Camouflage in sand?", correct: "Lizard", choices: ["Lizard", "Polar bear", "Whale", "Bat"]),
        ShadowRound(silhouette: "🌿", prompt: "Makes food from sunlight?", correct: "Plant", choices: ["Plant", "Rock", "Cloud", "Metal"]),
        ShadowRound(silhouette: "🍄", prompt: "Breaks down dead things?", correct: "Mushroom", choices: ["Mushroom", "Grass", "Hawk", "Sun"]),
        ShadowRound(silhouette: "🐧", prompt: "Thick feathers for cold?", correct: "Penguin", choices: ["Penguin", "Camel", "Lizard", "Butterfly"]),
        ShadowRound(silhouette: "🦅", prompt: "Sharp talons for hunting?", correct: "Eagle", choices: ["Eagle", "Rabbit", "Deer", "Grasshopper"]),
        ShadowRound(silhouette: "🐢", prompt: "Hard shell protection?", correct: "Turtle", choices: ["Turtle", "Jellyfish", "Worm", "Frog"]),
    ]

    struct BubbleRound {
        let prompt: String
        let correctAnswers: Set<Int>
        let bubbles: [Int]
    }

    static func bubbleRound(grade: Grade) -> BubbleRound {
        let (prompt, answer) = mathProblem(grade: grade)
        if grade == .third, Bool.random() {
            let factor = Int.random(in: 2...6)
            let multiples = (1...4).map { factor * $0 }
            return BubbleRound(
                prompt: "Pop all multiples of \(factor)",
                correctAnswers: Set(multiples),
                bubbles: (multiples + mathDistractors(correct: answer, grade: grade)).shuffled()
            )
        }
        var bubbles = Set([answer])
        while bubbles.count < 6 {
            bubbles.insert(answer + Int.random(in: -15...15))
        }
        return BubbleRound(
            prompt: prompt + " = ?",
            correctAnswers: [answer],
            bubbles: Array(bubbles).shuffled()
        )
    }

    struct FrogFlyRound {
        let question: String
        let insects: [(label: String, isCorrect: Bool)]
    }

    static func frogFlyRound(grade: Grade, round: Int) -> FrogFlyRound {
        let pool = grade == .second ? secondFrogFly : thirdFrogFly
        return pool[(round - 1) % pool.count]
    }

    private static let secondFrogFly: [FrogFlyRound] = [
        FrogFlyRound(question: "Which is living?", insects: [("Rock", false), ("Tree", true), ("Chair", false), ("Pencil", false)]),
        FrogFlyRound(question: "Which is a liquid?", insects: [("Ice", false), ("Steam", false), ("Water", true), ("Wood", false)]),
        FrogFlyRound(question: "Which needs sunlight?", insects: [("Flower", true), ("Rock", false), ("Toy", false), ("Sand", false)]),
        FrogFlyRound(question: "Which has babies?", insects: [("Dog", true), ("Cloud", false), ("Stone", false), ("Air", false)]),
        FrogFlyRound(question: "Which is a gas?", insects: [("Juice", false), ("Air", true), ("Milk", false), ("Honey", false)]),
        FrogFlyRound(question: "Which grows?", insects: [("Seed", true), ("Glass", false), ("Metal", false), ("Plastic", false)]),
        FrogFlyRound(question: "Which breathes?", insects: [("Fish", true), ("Rock", false), ("Water", false), ("Soil", false)]),
        FrogFlyRound(question: "Which is nonliving?", insects: [("Butterfly", false), ("Sun", false), ("Book", true), ("Bird", false)]),
        FrogFlyRound(question: "Which is solid?", insects: [("Rain", false), ("Steam", false), ("Rock", true), ("Juice", false)]),
        FrogFlyRound(question: "Which changes with seasons?", insects: [("Tree", true), ("Gold", false), ("Diamond", false), ("Glass", false)]),
    ]

    private static let thirdFrogFly: [FrogFlyRound] = [
        FrogFlyRound(question: "Which is a decomposer?", insects: [("Mushroom", true), ("Grass", false), ("Hawk", false), ("Rabbit", false)]),
        FrogFlyRound(question: "Which is a producer?", insects: [("Algae", true), ("Fox", false), ("Snake", false), ("Wolf", false)]),
        FrogFlyRound(question: "Which is a consumer?", insects: [("Corn", false), ("Deer", true), ("Sun", false), ("Rock", false)]),
        FrogFlyRound(question: "Webbed feet help ___?", insects: [("Swimming", true), ("Flying high", false), ("Digging", false), ("Climbing trees", false)]),
        FrogFlyRound(question: "Thick fur helps in ___?", insects: [("Cold places", true), ("Desert heat", false), ("Deep ocean", false), ("Rain only", false)]),
        FrogFlyRound(question: "Gills help fish ___?", insects: [("Breathe underwater", true), ("Fly", false), ("Climb", false), ("Hibernate", false)]),
        FrogFlyRound(question: "Camouflage helps animals ___?", insects: [("Hide", true), ("Swim faster", false), ("Grow taller", false), ("Make food", false)]),
        FrogFlyRound(question: "Migration means animals ___?", insects: [("Travel seasonally", true), ("Sleep all day", false), ("Change color", false), ("Grow roots", false)]),
        FrogFlyRound(question: "A food chain starts with ___?", insects: [("Sun", true), ("Lion", false), ("Mushroom", false), ("Rock", false)]),
        FrogFlyRound(question: "Pollinators help plants ___?", insects: [("Make seeds", true), ("Grow rocks", false), ("Freeze", false), ("Sink", false)]),
    ]

    struct PotionRound {
        let goal: String
        let ingredients: [String]
        let correctSet: Set<String>
        let minPick: Int
        let maxPick: Int
        let failMessage: String
    }

    static func potionRound(grade: Grade, round: Int) -> PotionRound {
        let pool = grade == .second ? secondPotions : thirdPotions
        return pool[(round - 1) % pool.count]
    }

    private static let secondPotions: [PotionRound] = [
        PotionRound(goal: "Brew a solid potion", ingredients: ["Ice", "Rock", "Water", "Steam", "Wood", "Juice"], correctSet: ["Ice", "Rock", "Wood"], minPick: 2, maxPick: 3, failMessage: "Oops! That fizzed into a puddle!"),
        PotionRound(goal: "Brew a liquid potion", ingredients: ["Milk", "Sand", "Rain", "Air", "Metal", "Honey"], correctSet: ["Milk", "Rain", "Honey"], minPick: 2, maxPick: 3, failMessage: "Poof! Wrong state of matter!"),
        PotionRound(goal: "Mix a gas potion", ingredients: ["Steam", "Oxygen", "Juice", "Ice", "Rock", "Oil"], correctSet: ["Steam", "Oxygen"], minPick: 2, maxPick: 2, failMessage: "Bubble bubble — not a gas!"),
        PotionRound(goal: "Make a flexible mix", ingredients: ["Rubber band", "Glass", "Clay", "Paper", "Diamond", "Water"], correctSet: ["Rubber band", "Clay", "Paper"], minPick: 2, maxPick: 3, failMessage: "Too stiff! Try something bendy."),
        PotionRound(goal: "Make a shiny mix", ingredients: ["Foil", "Cotton", "Coin", "Feather", "Mirror", "Sand"], correctSet: ["Foil", "Coin", "Mirror"], minPick: 2, maxPick: 3, failMessage: "Dull reaction! Pick shinier things."),
        PotionRound(goal: "Make a rough mix", ingredients: ["Sandpaper", "Silk", "Bark", "Glass", "Velvet", "Gravel"], correctSet: ["Sandpaper", "Bark", "Gravel"], minPick: 2, maxPick: 3, failMessage: "Too smooth! Rough it up."),
        PotionRound(goal: "Dissolve in water", ingredients: ["Salt", "Sand", "Sugar", "Rock", "Food coloring", "Pebble"], correctSet: ["Salt", "Sugar", "Food coloring"], minPick: 2, maxPick: 3, failMessage: "Nothing dissolved — try again!"),
        PotionRound(goal: "Float on water", ingredients: ["Cork", "Coin", "Wood chip", "Metal bolt", "Leaf", "Stone"], correctSet: ["Cork", "Wood chip", "Leaf"], minPick: 2, maxPick: 3, failMessage: "Splash! Those sank."),
    ]

    private static let thirdPotions: [PotionRound] = [
        PotionRound(goal: "Mix a solution", ingredients: ["Salt water", "Sand", "Sugar water", "Oil", "Gravel", "Pepper"], correctSet: ["Salt water", "Sugar water"], minPick: 2, maxPick: 2, failMessage: "Separated layers — not a solution!"),
        PotionRound(goal: "Make a mixture", ingredients: ["Trail mix", "Pure gold", "Salad", "Distilled water", "Iron", "Oxygen gas"], correctSet: ["Trail mix", "Salad"], minPick: 1, maxPick: 2, failMessage: "Too pure! Mix different things."),
        PotionRound(goal: "Conduct electricity", ingredients: ["Copper wire", "Plastic", "Salt water", "Rubber", "Iron nail", "Wood"], correctSet: ["Copper wire", "Salt water", "Iron nail"], minPick: 2, maxPick: 3, failMessage: "No spark! Pick conductors."),
        PotionRound(goal: "Insulate heat", ingredients: ["Wool", "Metal pan", "Foam", "Aluminum foil", "Cotton", "Steel"], correctSet: ["Wool", "Foam", "Cotton"], minPick: 2, maxPick: 3, failMessage: "Too hot to handle!"),
        PotionRound(goal: "Magnetic mix", ingredients: ["Iron filings", "Plastic", "Nickel", "Wood", "Cobalt", "Paper"], correctSet: ["Iron filings", "Nickel", "Cobalt"], minPick: 2, maxPick: 3, failMessage: "No pull! Try magnetic metals."),
        PotionRound(goal: "Absorb water", ingredients: ["Sponge", "Wax", "Paper towel", "Plastic wrap", "Cotton", "Glass"], correctSet: ["Sponge", "Paper towel", "Cotton"], minPick: 2, maxPick: 3, failMessage: "Water rolled right off!"),
        PotionRound(goal: "Repel water", ingredients: ["Wax", "Oil", "Paper", "Feather coating", "Sand", "Salt"], correctSet: ["Wax", "Oil", "Feather coating"], minPick: 2, maxPick: 3, failMessage: "Got soggy! Pick water-repellent items."),
        PotionRound(goal: "Recycle pile", ingredients: ["Aluminum can", "Banana peel", "Glass bottle", "Styrofoam", "Newspaper", "Battery"], correctSet: ["Aluminum can", "Glass bottle", "Newspaper"], minPick: 2, maxPick: 3, failMessage: "Trash mix-up! Sort again."),
    ]

    enum UnderwaterZone: String, CaseIterable {
        case surface, reef, deep

        var title: String {
            switch self {
            case .surface: return "Surface"
            case .reef: return "Coral Reef"
            case .deep: return "Deep Sea"
            }
        }

        var emoji: String {
            switch self {
            case .surface: return "🌊"
            case .reef: return "🪸"
            case .deep: return "🌑"
            }
        }

        var creature: String {
            switch self {
            case .surface: return "🐬"
            case .reef: return "🐠"
            case .deep: return "🐙"
            }
        }
    }

    static func underwaterQuestion(grade: Grade, zone: UnderwaterZone, round: Int) -> (question: String, choices: [String], correct: String) {
        if round % 2 == 0 || zone == .surface {
            let (prompt, answer) = mathProblem(grade: grade)
            return (prompt + " = ?", numericChoices(correct: answer), "\(answer)")
        }
        let science = grade == .second ? secondUnderwaterScience : thirdUnderwaterScience
        let index = ((round + zone.hashValue) % science.count + science.count) % science.count
        let pick = science[index]
        return (pick.0, pick.1.shuffled(), pick.2)
    }

    private static let secondUnderwaterScience: [(String, [String], String)] = [
        ("Fish breathe with ___?", ["Gills", "Lungs", "Leaves", "Wings"], "Gills"),
        ("Coral lives in the ___?", ["Ocean", "Desert", "Arctic", "Cave"], "Ocean"),
        ("Whales are ___?", ["Mammals", "Fish", "Insects", "Rocks"], "Mammals"),
    ]

    private static let thirdUnderwaterScience: [(String, [String], String)] = [
        ("Algae is a ___?", ["Producer", "Consumer", "Decomposer", "Mineral"], "Producer"),
        ("Deep sea animals often ___?", ["Glow", "Fly", "Grow leaves", "Lay eggs on land"], "Glow"),
        ("Ocean currents move ___?", ["Water", "Rocks", "Clouds", "Trees"], "Water"),
    ]

    // MARK: - Tier 3 games

    enum MeteorOperation { case add, multiply }

    struct MeteorRound {
        let target: Int
        let operation: MeteorOperation
        let meteors: [Int]
    }

    static func meteorRound(grade: Grade, round: Int) -> MeteorRound {
        let op: MeteorOperation = grade == .second ? .add : (round % 2 == 0 ? .multiply : .add)
        let target: Int
        let meteors: [Int]
        switch op {
        case .add:
            target = grade == .second ? Int.random(in: 10...30) : Int.random(in: 20...60)
            let a = Int.random(in: 1..<target)
            let b = target - a
            var nums = [a, b]
            if a == b { nums.append(a) }
            while nums.count < 8 {
                nums.append(Int.random(in: 1...max(target, 12)))
            }
            meteors = nums.shuffled()
        case .multiply:
            target = [12, 18, 24, 30, 36, 48, 56, 72].randomElement()!
            let pairs = (2...12).flatMap { a in
                (a...12).map { b in (a, b) }
            }.filter { $0.0 * $0.1 == target }
            let pair = pairs.randomElement() ?? (2, target / 2)
            var nums = [pair.0, pair.1]
            if pair.0 == pair.1 { nums.append(pair.0) }
            while nums.count < 8 {
                nums.append(Int.random(in: 2...12))
            }
            meteors = nums.shuffled()
        }
        return MeteorRound(target: target, operation: op, meteors: meteors)
    }

    struct MysteryCase {
        let title: String
        let intro: String
        let culprit: String
        let clues: [(chapter: String, question: String, choices: [String], correct: String, reveal: String)]
    }

    static func mysteryCase(grade: Grade) -> MysteryCase {
        let pool = grade == .second ? secondMysteries : thirdMysteries
        return pool.randomElement()!
    }

    private static let secondMysteries: [MysteryCase] = [
        MysteryCase(
            title: "Wilting Garden",
            intro: "Plants in the school garden are dying. Follow the clues!",
            culprit: "Too much salt in soil",
            clues: [
                ("Clue 1", "8 + 5 = ?", ["12", "13", "14", "15"], "13", "The soil tester reads 13 — very salty!"),
                ("Clue 2", "Plants need ___ to make food.", ["Sunlight", "Rocks", "Plastic", "Metal"], "Sunlight", "Sun is fine — look elsewhere."),
                ("Clue 3", "20 − 7 = ?", ["11", "12", "13", "14"], "13", "Watering can holds 13 cups — someone over-salted!"),
                ("Clue 4", "Salt in soil makes plants ___?", ["Wilt", "Grow taller", "Turn blue", "Fly"], "Wilt", "Salt poisoned the roots!"),
                ("Clue 5", "Fix: wash soil with ___?", ["Fresh water", "More salt", "Paint", "Sand only"], "Fresh water", "Case solved! Rinse the salt away."),
            ]
        ),
        MysteryCase(
            title: "Dry Pond",
            intro: "The pond dried up overnight. What happened?",
            culprit: "Broken water cycle",
            clues: [
                ("Clue 1", "6 × 2 = ?", ["10", "12", "14", "16"], "12", "12 hours since rain — too long!"),
                ("Clue 2", "Evaporation turns water into ___?", ["Gas", "Rock", "Metal", "Wood"], "Gas", "Water vapor escaped."),
                ("Clue 3", "15 + 9 = ?", ["22", "23", "24", "25"], "24", "Sprinkler ran 24 hours — pipe burst!"),
                ("Clue 4", "Clouds bring ___?", ["Rain", "Rocks", "Fire", "Salt"], "Rain", "No rain clouds formed."),
                ("Clue 5", "Fix the broken ___?", ["Sprinkler pipe", "Tree branch", "Bench", "Flag"], "Sprinkler pipe", "Water cycle restored!"),
            ]
        ),
    ]

    private static let thirdMysteries: [MysteryCase] = [
        MysteryCase(
            title: "Sick Fish Tank",
            intro: "Fish are gasping at the surface. Investigate!",
            culprit: "Low oxygen",
            clues: [
                ("Clue 1", "7 × 4 = ?", ["26", "28", "30", "32"], "28", "Filter off for 28 hours!"),
                ("Clue 2", "Fish get oxygen from ___?", ["Water", "Rocks", "Glass", "Plastic plants"], "Water", "Water needs oxygen too."),
                ("Clue 3", "Algae overgrowth uses up ___?", ["Oxygen", "Sunlight only", "Glass", "Gravel color"], "Oxygen", "Too much algae!"),
                ("Clue 4", "48 ÷ 6 = ?", ["6", "7", "8", "9"], "8", "8 fish — all struggling."),
                ("Clue 5", "Clean tank and run ___?", ["Filter & aerator", "Heater only", "More fish", "Food"], "Filter & aerator", "Oxygen restored!"),
            ]
        ),
        MysteryCase(
            title: "Forest Fire Clue",
            intro: "Smoke in the woods — but no lightning. Why?",
            culprit: "Campfire left burning",
            clues: [
                ("Clue 1", "9 × 3 = ?", ["24", "27", "30", "33"], "27", "Campers left 27 minutes ago."),
                ("Clue 2", "Fire needs oxygen, fuel, and ___?", ["Heat", "Water", "Ice", "Wind only"], "Heat", "Embers still hot!"),
                ("Clue 3", "56 − 18 = ?", ["36", "38", "40", "42"], "38", "38°C — embers still burning."),
                ("Clue 4", "Best way to put out campfire?", ["Water & stir dirt", "Blow on it", "Add wood", "Walk away"], "Water & stir dirt", "Always douse campfires!"),
                ("Clue 5", "Who left the fire?", ["Careless campers", "Birds", "Rain", "Moon"], "Careless campers", "Mystery solved — stay safe!"),
            ]
        ),
    ]

    enum TimeEra: String, CaseIterable {
        case egypt, rome, medieval

        var title: String {
            switch self {
            case .egypt: return "Ancient Egypt"
            case .rome: return "Roman Market"
            case .medieval: return "Medieval Fair"
            }
        }

        var emoji: String {
            switch self {
            case .egypt: return "🏺"
            case .rome: return "🏛️"
            case .medieval: return "🏰"
            }
        }
    }

    static func timeTravelerQuestion(grade: Grade, era: TimeEra, round: Int) -> (question: String, choices: [String], correct: String) {
        let pool: [(TimeEra, String, [String], String)]
        if grade == .second {
            pool = [
                (.egypt, "3 cubits + 2 cubits = ? cubits", ["4", "5", "6", "7"], "5"),
                (.egypt, "10 grain sacks − 4 = ?", ["5", "6", "7", "8"], "6"),
                (.rome, "2 coins + 3 coins = ? coins", ["4", "5", "6", "7"], "5"),
                (.rome, "12 grapes ÷ 3 baskets = ?", ["3", "4", "5", "6"], "4"),
                (.medieval, "5 apples + 4 apples = ?", ["7", "8", "9", "10"], "9"),
                (.medieval, "20 pennies − 8 = ?", ["10", "11", "12", "13"], "12"),
            ]
        } else {
            pool = [
                (.egypt, "A pyramid step is 3 ft. Four steps = ? ft", ["10", "11", "12", "13"], "12"),
                (.egypt, "6 scrolls × 2 scribes = ? copies", ["10", "11", "12", "13"], "12"),
                (.rome, "4 denarii × 3 loaves = ? denarii", ["10", "11", "12", "13"], "12"),
                (.rome, "48 soldiers ÷ 6 tents = ? per tent", ["6", "7", "8", "9"], "8"),
                (.medieval, "3 knights × 5 shields = ? shields", ["12", "14", "15", "16"], "15"),
                (.medieval, "100 yards of cloth − 37 = ?", ["61", "62", "63", "64"], "63"),
            ]
        }
        let eraPool = pool.filter { $0.0 == era }
        let pick = eraPool[(round - 1) % eraPool.count]
        return (pick.1, pick.2.shuffled(), pick.3)
    }

    struct TerrariumPiece: Identifiable, Hashable {
        let id: String
        let label: String
        let emoji: String
        let kind: String // producer, consumer, terrain
    }

    static let terrariumPieces: [TerrariumPiece] = [
        TerrariumPiece(id: "grass", label: "Grass", emoji: "🌿", kind: "producer"),
        TerrariumPiece(id: "moss", label: "Moss", emoji: "🪴", kind: "producer"),
        TerrariumPiece(id: "fern", label: "Fern", emoji: "🌱", kind: "producer"),
        TerrariumPiece(id: "ladybug", label: "Ladybug", emoji: "🐞", kind: "consumer"),
        TerrariumPiece(id: "snail", label: "Snail", emoji: "🐌", kind: "consumer"),
        TerrariumPiece(id: "frog", label: "Frog", emoji: "🐸", kind: "consumer"),
        TerrariumPiece(id: "soil", label: "Soil", emoji: "🪨", kind: "terrain"),
        TerrariumPiece(id: "water", label: "Pond", emoji: "💧", kind: "terrain"),
        TerrariumPiece(id: "log", label: "Log", emoji: "🪵", kind: "terrain"),
    ]

    static func terrariumQuestion(grade: Grade, round: Int) -> (question: String, choices: [String], correct: String, reward: TerrariumPiece) {
        let piece = terrariumPieces[(round - 1) % terrariumPieces.count]
        if grade == .second {
            let qs: [(String, [String], String)] = [
                ("Plants are ___?", ["Producers", "Consumers", "Rocks", "Gases"], "Producers"),
                ("Animals that eat plants are ___?", ["Consumers", "Producers", "Sun", "Water"], "Consumers"),
                ("Soil is ___?", ["Terrain", "Producer", "Consumer", "Sky"], "Terrain"),
            ]
            let q = qs[(round - 1) % qs.count]
            return (q.0, q.1.shuffled(), q.2, piece)
        }
        let qs: [(String, [String], String)] = [
            ("Balance needs more ___ than consumers.", ["Producers", "Rocks", "Plastic", "Metal"], "Producers"),
            ("A food web needs a ___?", ["Producer", "Car", "Cloud only", "Plastic"], "Producer"),
            ("Decomposers return nutrients to ___?", ["Soil", "Sky", "Space", "Ice only"], "Soil"),
        ]
        let q = qs[(round - 1) % qs.count]
        return (q.0, q.1.shuffled(), q.2, piece)
    }

    struct TownBuilding: Identifiable, Hashable {
        let id: String
        let label: String
        let emoji: String
        let lumber: Int
        let bricks: Int
        let glass: Int
    }

    static let townBuildings: [TownBuilding] = [
        TownBuilding(id: "house", label: "House", emoji: "🏠", lumber: 2, bricks: 1, glass: 0),
        TownBuilding(id: "park", label: "Park", emoji: "🌳", lumber: 1, bricks: 0, glass: 0),
        TownBuilding(id: "shop", label: "Shop", emoji: "🏪", lumber: 1, bricks: 2, glass: 1),
        TownBuilding(id: "school", label: "School", emoji: "🏫", lumber: 2, bricks: 2, glass: 2),
        TownBuilding(id: "library", label: "Library", emoji: "📚", lumber: 1, bricks: 1, glass: 2),
    ]

    static func townBuilderProblem(grade: Grade, round: Int) -> (question: String, choices: [String], correct: String, lumber: Int, bricks: Int, glass: Int) {
        if grade == .second {
            let problems: [(String, Int, (Int, Int, Int))] = [
                ("Mia has 5 apples and buys 3 more. Total?", 8, (1, 0, 0)),
                ("A board is 12 inches. Cut off 4. Left?", 8, (2, 0, 0)),
                ("Tom has 15¢ and spends 7¢. Left?", 8, (0, 1, 0)),
                ("3 windows + 2 windows = ?", 5, (0, 0, 1)),
            ]
            let p = problems[(round - 1) % problems.count]
            return (p.0, numericChoices(correct: p.1), "\(p.1)", p.2.0, p.2.1, p.2.2)
        }
        let problems: [(String, Int, (Int, Int, Int))] = [
            ("A park needs 24 feet of fence. Already have 16. Need?", 8, (1, 1, 0)),
            ("4 rooms × 3 windows = ? windows", 12, (0, 0, 2)),
            ("$5 + $3 + $2 = ?", 10, (2, 1, 0)),
            ("48 bricks ÷ 6 walls = ? per wall", 8, (0, 2, 1)),
        ]
        let p = problems[(round - 1) % problems.count]
        return (p.0, numericChoices(correct: p.1), "\(p.1)", p.2.0, p.2.1, p.2.2)
    }
}
