import Foundation

/// Runtime problem generation for Math POT Level 2 topics (T032–T059).
enum POT2ProblemGenerator {
    static func generate(topic: Topic, difficulty: Difficulty) -> Problem {
        guard let code = topic.potCode else {
            return fallback(topic: topic, difficulty: difficulty)
        }
        switch code {
        case "T032": return t032Clock(topic: topic, difficulty: difficulty)
        case "T033": return t033BoxDiagram(topic: topic, difficulty: difficulty)
        case "T034": return t034AddLarge(topic: topic, difficulty: difficulty)
        case "T035": return t035SubtractLarge(topic: topic, difficulty: difficulty)
        case "T036": return t036FactFamilies(topic: topic, difficulty: difficulty)
        case "T037": return t037ReadWriteNumbers(topic: topic, difficulty: difficulty)
        case "T038": return t038CompareNumbers(topic: topic, difficulty: difficulty)
        case "T039": return t039BuildFromDigits(topic: topic, difficulty: difficulty)
        case "T040": return t040PlaceValue(topic: topic, difficulty: difficulty)
        case "T041": return t041ElapsedTime(topic: topic, difficulty: difficulty)
        case "T042": return t042ChickensRabbits(topic: topic, difficulty: difficulty)
        case "T043": return t043AddThreePlus(topic: topic, difficulty: difficulty)
        case "T044": return t044SolidGeometry(topic: topic, difficulty: difficulty)
        case "T045": return t045BarGraph(topic: topic, difficulty: difficulty)
        case "T046": return t046CoinsChange(topic: topic, difficulty: difficulty)
        case "T047": return t047Fractions(topic: topic, difficulty: difficulty)
        case "T048": return t048LineGraph(topic: topic, difficulty: difficulty)
        case "T049": return t049Rounding(topic: topic, difficulty: difficulty)
        case "T050": return t050VennTwo(topic: topic, difficulty: difficulty)
        case "T051": return t051CubeStack(topic: topic, difficulty: difficulty)
        case "T052": return t052VennThree(topic: topic, difficulty: difficulty)
        case "T053": return t053FrogHole(topic: topic, difficulty: difficulty)
        case "T054": return t054MissingNumber(topic: topic, difficulty: difficulty)
        case "T055": return t055ComparisonChain(topic: topic, difficulty: difficulty)
        case "T056": return t056LogicGrid(topic: topic, difficulty: difficulty)
        case "T057": return t057MultiplicationIntro(topic: topic, difficulty: difficulty)
        case "T058": return t058VennWordProblems(topic: topic, difficulty: difficulty)
        case "T059": return t059MultiplyOneDigit(topic: topic, difficulty: difficulty)
        default: return fallback(topic: topic, difficulty: difficulty)
        }
    }

    // MARK: - T032 Clock

    private static func t032Clock(topic: Topic, difficulty: Difficulty) -> Problem {
        let hour = Int.random(in: 1...12)
        let minute: Int
        switch difficulty {
        case .easy: minute = [0, 30].randomElement() ?? 0
        case .medium: minute = [0, 15, 30, 45].randomElement() ?? 0
        case .hard: minute = Int.random(in: 0...11) * 5
        }
        let answer = MathProblemHelpers.formatTime(hour: hour, minute: minute)
        return Problem(
            questionText: "What time does the clock show?",
            visual: .clockFace(hour: hour, minute: minute),
            answerType: .multipleChoice,
            correctAnswer: answer,
            choices: MathProblemHelpers.multipleChoiceOptions(
                correct: answer,
                distractors: [
                    MathProblemHelpers.formatTime(hour: (hour % 12) + 1, minute: minute),
                    MathProblemHelpers.formatTime(hour: hour, minute: (minute + 15) % 60),
                    MathProblemHelpers.formatTime(hour: max(1, hour - 1), minute: minute)
                ]
            ),
            teksId: topic.teks
        )
    }

    // MARK: - T033 Box diagram

    private static func t033BoxDiagram(topic: Topic, difficulty: Difficulty) -> Problem {
        let partA = Int.random(in: range(for: difficulty, easy: 2..<10, medium: 10..<50, hard: 50...200))
        let partB = Int.random(in: range(for: difficulty, easy: 2..<10, medium: 10..<50, hard: 50...200))
        let whole = partA + partB
        if Bool.random() {
            return Problem(
                questionText: "Box diagram: Part A = \(partA), Part B = \(partB). What is the whole?",
                answerType: .numberEntry,
                correctAnswer: "\(whole)",
                hint: "Add the two parts.",
                teksId: topic.teks
            )
        }
        let hidden = Bool.random() ? partA : partB
        let shown = hidden == partA ? partB : partA
        return Problem(
            questionText: "Box diagram: one part is \(shown), the whole is \(whole). What is the missing part?",
            answerType: .numberEntry,
            correctAnswer: "\(hidden)",
            hint: "Subtract the known part from the whole.",
            teksId: topic.teks
        )
    }

    // MARK: - T034 Add large

    private static func t034AddLarge(topic: Topic, difficulty: Difficulty) -> Problem {
        let (a, b) = additionPair(difficulty: difficulty, digits: difficulty == .hard ? 4 : 3)
        return Problem(
            questionText: "What is \(a) + \(b)?",
            answerType: .numberEntry,
            correctAnswer: "\(a + b)",
            hint: "Line up place values and regroup if needed.",
            teksId: topic.teks
        )
    }

    // MARK: - T035 Subtract large

    private static func t035SubtractLarge(topic: Topic, difficulty: Difficulty) -> Problem {
        let (a, b) = subtractionPair(difficulty: difficulty, digits: difficulty == .hard ? 4 : 3)
        return Problem(
            questionText: "What is \(a) − \(b)?",
            answerType: .numberEntry,
            correctAnswer: "\(a - b)",
            hint: "Borrow from the next place if you need to.",
            teksId: topic.teks
        )
    }

    // MARK: - T036 Fact families

    private static func t036FactFamilies(topic: Topic, difficulty: Difficulty) -> Problem {
        let a = Int.random(in: 2...(difficulty == .easy ? 8 : 12))
        let b = Int.random(in: 1...(difficulty == .easy ? 9 : 15))
        let sum = a + b
        let variant = Int.random(in: 0...2)
        switch variant {
        case 0:
            return Problem(
                questionText: "Fact family: \(a) + \(b) = \(sum). What is \(sum) − \(a)?",
                answerType: .numberEntry,
                correctAnswer: "\(b)",
                teksId: topic.teks
            )
        case 1:
            return Problem(
                questionText: "Which fact belongs with \(a) + \(b) = \(sum)?",
                answerType: .multipleChoice,
                correctAnswer: "\(sum) − \(b) = \(a)",
                choices: MathProblemHelpers.multipleChoiceOptions(correct: "\(sum) − \(b) = \(a)", distractors: [
                    "\(sum) + \(b) = \(a)",
                    "\(a) − \(b) = \(sum)",
                    "\(sum) × \(a) = \(b)"
                ]),
                teksId: topic.teks
            )
        default:
            return Problem(
                questionText: "Fill in the blank: \(a) + ___ = \(sum)",
                answerType: .numberEntry,
                correctAnswer: "\(b)",
                teksId: topic.teks
            )
        }
    }

    // MARK: - T037 Read/write numbers

    private static func t037ReadWriteNumbers(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = Int.random(in: range(for: difficulty, easy: 100..<1000, medium: 1000..<5000, hard: 5000...9999))
        if Bool.random() {
            return Problem(
                questionText: "What number is \(formattedNumber(n))?",
                answerType: .numberEntry,
                correctAnswer: "\(n)",
                teksId: topic.teks
            )
        }
        let thousands = n / 1000
        let hundreds = (n % 1000) / 100
        let tens = (n % 100) / 10
        let ones = n % 10
        return Problem(
            questionText: "What is the expanded form of \(formattedNumber(n))?\n(thousands + hundreds + tens + ones)",
            answerType: .numberEntry,
            correctAnswer: "\(thousands * 1000) + \(hundreds * 100) + \(tens * 10) + \(ones)",
            hint: "Break the number into place values.",
            teksId: topic.teks
        )
    }

    // MARK: - T038 Compare

    private static func t038CompareNumbers(topic: Topic, difficulty: Difficulty) -> Problem {
        var a = Int.random(in: range(for: difficulty, easy: 100..<1000, medium: 500..<5000, hard: 1000...9999))
        var b = Int.random(in: range(for: difficulty, easy: 100..<1000, medium: 500..<5000, hard: 1000...9999))
        if difficulty == .hard && Bool.random() {
            let base = Int.random(in: 1000...9000)
            a = base + Int.random(in: 0...9)
            b = base + Int.random(in: 0...9)
        }
        let symbol: String
        if a > b { symbol = ">" } else if a < b { symbol = "<" } else { symbol = "=" }
        return Problem(
            questionText: "Compare: \(formattedNumber(a)) ___ \(formattedNumber(b))",
            answerType: .tapSelection,
            correctAnswer: symbol,
            teksId: topic.teks,
            tapOptions: [">", "<", "="]
        )
    }

    // MARK: - T039 Build from digits

    private static func t039BuildFromDigits(topic: Topic, difficulty: Difficulty) -> Problem {
        let count = difficulty == .easy ? 3 : 4
        var digits = (0..<count).map { _ in Int.random(in: 1...9) }
        while Set(digits).count < count - 1 { digits = (0..<count).map { _ in Int.random(in: 1...9) } }
        let sorted = digits.sorted()
        let largest = Int(sorted.reversed().map(String.init).joined()) ?? 0
        let smallest = Int(sorted.map(String.init).joined()) ?? 0
        let wantLargest = Bool.random()
        return Problem(
            questionText: "Use digits \(digits.map(String.init).joined(separator: ", ")) once each. What is the \(wantLargest ? "largest" : "smallest") number you can make?",
            answerType: .numberEntry,
            correctAnswer: "\(wantLargest ? largest : smallest)",
            teksId: topic.teks
        )
    }

    // MARK: - T040 Place value

    private static func t040PlaceValue(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = Int.random(in: range(for: difficulty, easy: 100..<1000, medium: 1000..<5000, hard: 5000...9999))
        let places = ["thousands", "hundreds", "tens", "ones"]
        let values = [n / 1000, (n % 1000) / 100, (n % 100) / 10, n % 10]
        let idx = Int.random(in: 0..<4)
        return Problem(
            questionText: "In \(formattedNumber(n)), what is the \(places[idx]) digit?",
            answerType: .numberEntry,
            correctAnswer: "\(values[idx])",
            hint: "Find the digit in the \(places[idx]) place.",
            teksId: topic.teks
        )
    }

    // MARK: - T041 Elapsed time

    private static func t041ElapsedTime(topic: Topic, difficulty: Difficulty) -> Problem {
        let startHour = Int.random(in: 1...10)
        let startMinute: Int
        let elapsedMinutes: Int
        switch difficulty {
        case .easy:
            startMinute = 0
            elapsedMinutes = Int.random(in: 1...3) * 60
        case .medium:
            startMinute = [0, 30].randomElement() ?? 0
            elapsedMinutes = Int.random(in: 1...4) * 30
        case .hard:
            startMinute = Int.random(in: 0...11) * 5
            elapsedMinutes = Int.random(in: 2...8) * 15
        }
        let totalStart = startHour * 60 + startMinute
        let totalEnd = totalStart + elapsedMinutes
        let endHour24 = totalEnd / 60
        let endHour = endHour24 % 12 == 0 ? 12 : endHour24 % 12
        let endMinute = totalEnd % 60
        return Problem(
            questionText: "Start: \(MathProblemHelpers.formatTime(hour: startHour, minute: startMinute)). Elapsed: \(elapsedMinutes) minutes. What time do you end?",
            visual: .clockFace(hour: startHour, minute: startMinute),
            answerType: .numberEntry,
            correctAnswer: MathProblemHelpers.formatTime(hour: endHour, minute: endMinute),
            hint: "Add the minutes. Regroup 60 minutes into 1 hour.",
            teksId: topic.teks
        )
    }

    // MARK: - T042 Chickens & rabbits

    private static func t042ChickensRabbits(topic: Topic, difficulty: Difficulty) -> Problem {
        let maxHeads = difficulty == .easy ? 10 : (difficulty == .medium ? 20 : 30)
        let rabbits = Int.random(in: 1..<maxHeads)
        let chickens = maxHeads - rabbits
        let heads = chickens + rabbits
        let legs = chickens * 2 + rabbits * 4
        let askChickens = Bool.random()
        return Problem(
            questionText: "A farm has \(heads) heads and \(legs) legs. Each chicken has 2 legs and each rabbit has 4 legs. How many \(askChickens ? "chickens" : "rabbits")?",
            answerType: .numberEntry,
            correctAnswer: "\(askChickens ? chickens : rabbits)",
            hint: "Try a table: chickens × 2 + rabbits × 4 = legs.",
            teksId: topic.teks
        )
    }

    // MARK: - T043 Add three+

    private static func t043AddThreePlus(topic: Topic, difficulty: Difficulty) -> Problem {
        let count = difficulty == .easy ? 3 : 4
        let nums = (0..<count).map { _ in Int.random(in: range(for: difficulty, easy: 10..<100, medium: 100..<500, hard: 200...800)) }
        return Problem(
            questionText: "What is \(nums.map(String.init).joined(separator: " + "))?",
            answerType: .numberEntry,
            correctAnswer: "\(nums.reduce(0, +))",
            hint: "Add two numbers first, then keep going.",
            teksId: topic.teks
        )
    }

    // MARK: - T044 Solids

    private static func t044SolidGeometry(topic: Topic, difficulty: Difficulty) -> Problem {
        let shapes: [(String, Int, Int, Int)] = [
            ("cube", 6, 12, 8),
            ("rectangular prism", 6, 12, 8),
            ("square pyramid", 5, 8, 5),
            ("triangular prism", 5, 9, 6),
            ("cylinder", 2, 2, 0),
            ("cone", 1, 1, 1),
            ("sphere", 0, 0, 0)
        ]
        let s = shapes.randomElement() ?? shapes[0]
        let ask = ["faces", "edges", "vertices"].randomElement() ?? "faces"
        let answer: Int
        switch ask {
        case "faces": answer = s.1
        case "edges": answer = s.2
        default: answer = s.3
        }
        return Problem(
            questionText: "How many \(ask) does a \(s.0) have?",
            answerType: .numberEntry,
            correctAnswer: "\(answer)",
            teksId: topic.teks
        )
    }

    // MARK: - T045 Bar graph

    private static func t045BarGraph(topic: Topic, difficulty: Difficulty) -> Problem {
        let labels = ["Apples", "Bananas", "Grapes", "Oranges", "Pears"].shuffled().prefix(difficulty == .easy ? 3 : 5)
        let data = labels.map { ($0, Int.random(in: 2...12)) }
        let i = Int.random(in: 0..<data.count)
        let j = (i + 1) % data.count
        let visual = ProblemVisual.barGraph(data: data)
        if Bool.random() {
            return Problem(
                questionText: "How many \(data[i].0) were there?",
                visual: visual,
                answerType: .numberEntry,
                correctAnswer: "\(data[i].1)",
                teksId: topic.teks
            )
        }
        let more = max(data[i].1, data[j].1)
        let less = min(data[i].1, data[j].1)
        return Problem(
            questionText: "How many more \(data[i].1 >= data[j].1 ? data[i].0 : data[j].0) than \(data[i].1 < data[j].1 ? data[i].0 : data[j].0)?",
            visual: visual,
            answerType: .numberEntry,
            correctAnswer: "\(more - less)",
            teksId: topic.teks
        )
    }

    // MARK: - T046 Coins

    private static func t046CoinsChange(topic: Topic, difficulty: Difficulty) -> Problem {
        let coins = coinSet(difficulty: difficulty)
        let total = coins.reduce(0) { $0 + $1.cents }
        if difficulty == .easy || Bool.random() {
            return Problem(
                questionText: "What is the total value of these coins?",
                visual: .coins(coins),
                answerType: .numberEntry,
                correctAnswer: MathProblemHelpers.formatCents(total),
                teksId: topic.teks
            )
        }
        let price = Int.random(in: 1...max(1, total / 25)) * 25
        let paid = max(price, ((price + 99) / 100) * 100)
        return Problem(
            questionText: "You have \(MathProblemHelpers.formatCents(total)). You pay \(MathProblemHelpers.formatCents(paid)) for a snack that costs \(MathProblemHelpers.formatCents(price)). How much change?",
            visual: .coins(coins),
            answerType: .numberEntry,
            correctAnswer: MathProblemHelpers.formatCents(paid - price),
            teksId: topic.teks
        )
    }

    // MARK: - T047 Fractions

    private static func t047Fractions(topic: Topic, difficulty: Difficulty) -> Problem {
        let denom = difficulty == .easy ? [2, 4].randomElement()! : (difficulty == .medium ? [3, 6].randomElement()! : [3, 4, 6].randomElement()!)
        let numer = difficulty == .hard && Bool.random() ? Int.random(in: 1...2) : 1
        let total = denom * Int.random(in: 2...(difficulty == .easy ? 4 : 8))
        let part = total * numer / denom
        return Problem(
            questionText: "There are \(total) stars. What is \(numer)/\(denom) of the stars?",
            visual: .fractionCircle(numerator: numer, denominator: denom),
            answerType: .numberEntry,
            correctAnswer: "\(part)",
            hint: "Split into \(denom) equal groups. Take \(numer) group.",
            teksId: topic.teks
        )
    }

    // MARK: - T048 Line graph

    private static func t048LineGraph(topic: Topic, difficulty: Difficulty) -> Problem {
        let labels = ["Jan", "Feb", "Mar", "Apr", "May"].prefix(difficulty == .easy ? 4 : 5)
        let values = labels.map { _ in Int.random(in: 2...12) }
        let data = Array(zip(labels, values))
        let visual = ProblemVisual.lineGraph(labels: data.map(\.0), values: data.map(\.1))
        if Bool.random() {
            let i = Int.random(in: 0..<data.count)
            return Problem(
                questionText: "What was the value in \(data[i].0)?",
                visual: visual,
                answerType: .numberEntry,
                correctAnswer: "\(data[i].1)",
                teksId: topic.teks
            )
        }
        var bestJump = 0
        var bestPair = (0, 1)
        for i in 0..<(data.count - 1) {
            let jump = data[i + 1].1 - data[i].1
            if jump > bestJump { bestJump = jump; bestPair = (i, i + 1) }
        }
        return Problem(
            questionText: "Between which two months did the value increase the most?",
            visual: visual,
            answerType: .multipleChoice,
            correctAnswer: "\(data[bestPair.0].0) to \(data[bestPair.1].0)",
            choices: MathProblemHelpers.multipleChoiceOptions(
                correct: "\(data[bestPair.0].0) to \(data[bestPair.1].0)",
                distractors: data.indices.compactMap { i -> String? in
                    guard i < data.count - 1, i != bestPair.0 else { return nil }
                    return "\(data[i].0) to \(data[i + 1].0)"
                }.prefix(3).map { String($0) }
            ),
            teksId: topic.teks
        )
    }

    // MARK: - T049 Rounding

    private static func t049Rounding(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = Int.random(in: range(for: difficulty, easy: 15..<100, medium: 100..<1000, hard: 500...9999))
        if difficulty == .easy {
            let rounded = ((n + 5) / 10) * 10
            return Problem(
                questionText: "Round \(n) to the nearest ten.",
                answerType: .numberEntry,
                correctAnswer: "\(rounded)",
                teksId: topic.teks
            )
        }
        let rounded = ((n + 50) / 100) * 100
        return Problem(
            questionText: "Round \(formattedNumber(n)) to the nearest hundred.",
            answerType: .numberEntry,
            correctAnswer: "\(rounded)",
            teksId: topic.teks
        )
    }

    // MARK: - T050 Two-circle Venn

    private static func t050VennTwo(topic: Topic, difficulty: Difficulty) -> Problem {
        let labelA = "Art"
        let labelB = "Music"
        let onlyA = Int.random(in: 2...8)
        let onlyB = Int.random(in: 2...8)
        let both = Int.random(in: 1...5)
        let visual = ProblemVisual.vennDiagram2(onlyA: onlyA, onlyB: onlyB, both: both, labelA: labelA, labelB: labelB)
        if Bool.random() {
            return Problem(
                questionText: "How many students are in \(labelA) only?",
                visual: visual,
                answerType: .numberEntry,
                correctAnswer: "\(onlyA)",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "How many students are in \(labelA) or \(labelB) (the union)?",
            visual: visual,
            answerType: .numberEntry,
            correctAnswer: "\(onlyA + onlyB + both)",
            hint: "Add all three regions.",
            teksId: topic.teks
        )
    }

    // MARK: - T051 Cube stack

    private static func t051CubeStack(topic: Topic, difficulty: Difficulty) -> Problem {
        let rows = Int.random(in: 2...(difficulty == .easy ? 3 : 4))
        let cols = Int.random(in: 2...(difficulty == .easy ? 3 : 4))
        let hidden = difficulty == .hard ? Int.random(in: 1...3) : 0
        let total = rows * cols + hidden
        return Problem(
            questionText: "How many unit cubes are in this stack? (Count hidden cubes too.)",
            visual: .cubeStack(rows: rows, cols: cols, hidden: hidden),
            answerType: .numberEntry,
            correctAnswer: "\(total)",
            teksId: topic.teks
        )
    }

    // MARK: - T052 Three-circle Venn

    private static func t052VennThree(topic: Topic, difficulty: Difficulty) -> Problem {
        let onlyA = Int.random(in: 1...5)
        let onlyB = Int.random(in: 1...5)
        let onlyC = Int.random(in: 1...5)
        let ab = Int.random(in: 1...3)
        let ac = Int.random(in: 1...3)
        let bc = Int.random(in: 1...3)
        let abc = Int.random(in: 1...2)
        let visual = ProblemVisual.vennDiagram3(
            onlyA: onlyA, onlyB: onlyB, onlyC: onlyC,
            ab: ab, ac: ac, bc: bc, abc: abc,
            labelA: "Soccer", labelB: "Piano", labelC: "Art"
        )
        return Problem(
            questionText: "How many students are in all three clubs?",
            visual: visual,
            answerType: .numberEntry,
            correctAnswer: "\(abc)",
            teksId: topic.teks
        )
    }

    // MARK: - T053 Frog

    private static func t053FrogHole(topic: Topic, difficulty: Difficulty) -> Problem {
        let depth = Int.random(in: range(for: difficulty, easy: 5..<12, medium: 10..<20, hard: 15...30))
        let climb = Int.random(in: 3...max(4, depth / 3))
        let slip = Int.random(in: 1..<climb)
        let days = frogDays(depth: depth, climb: climb, slip: slip)
        return Problem(
            questionText: "A frog climbs \(climb) feet each day and slides back \(slip) feet each night. The hole is \(depth) feet deep. How many days until the frog gets out?",
            answerType: .numberEntry,
            correctAnswer: "\(days)",
            hint: "On the last day the frog climbs out and does not slide back.",
            teksId: topic.teks
        )
    }

    // MARK: - T054 Missing number

    private static func t054MissingNumber(topic: Topic, difficulty: Difficulty) -> Problem {
        if difficulty == .hard && Bool.random() {
            let factor = Int.random(in: 2...9)
            let product = factor * Int.random(in: 2...9)
            return Problem(
                questionText: "Fill in the blank: \(factor) × ___ = \(product)",
                answerType: .numberEntry,
                correctAnswer: "\(product / factor)",
                teksId: topic.teks
            )
        }
        let a = Int.random(in: 10...80)
        let b = Int.random(in: 10...50)
        let sum = a + b
        if Bool.random() {
            return Problem(
                questionText: "Fill in the blank: ___ + \(a) = \(sum)",
                answerType: .numberEntry,
                correctAnswer: "\(b)",
                teksId: topic.teks
            )
        }
        let minuend = Int.random(in: 50...120)
        let sub = Int.random(in: 10..<minuend)
        return Problem(
            questionText: "Fill in the blank: \(minuend) − ___ = \(minuend - sub)",
            answerType: .numberEntry,
            correctAnswer: "\(sub)",
            teksId: topic.teks
        )
    }

    // MARK: - T055 Comparison chain

    private static func t055ComparisonChain(topic: Topic, difficulty: Difficulty) -> Problem {
        let count = difficulty == .easy ? 3 : (difficulty == .medium ? 4 : 5)
        let names = ["Ali", "Ben", "Cam", "Dana", "Eli"].shuffled().prefix(count)
        let ordered = Array(names)
        var clues: [String] = []
        for i in 0..<(ordered.count - 1) {
            clues.append("\(ordered[i]) is taller than \(ordered[i + 1]).")
        }
        let askShortest = Bool.random()
        return Problem(
            questionText: clues.joined(separator: " ") + (askShortest ? " Who is shortest?" : " Who is tallest?"),
            answerType: .tapSelection,
            correctAnswer: askShortest ? ordered.last! : ordered.first!,
            teksId: topic.teks,
            tapOptions: ordered
        )
    }

    // MARK: - T056 Logic grid

    private static func t056LogicGrid(topic: Topic, difficulty: Difficulty) -> Problem {
        let mapping: [(kid: String, pet: String)] = [
            ("Maya", "Dog"),
            ("Sam", "Fish"),
            ("Zoe", "Cat")
        ]
        let ask = mapping.randomElement() ?? mapping[0]
        return Problem(
            questionText: "Logic clues:\n• Maya has a dog.\n• Sam has a fish.\n• Zoe has a cat.\nWho has the \(ask.pet.lowercased())?",
            answerType: .tapSelection,
            correctAnswer: ask.kid,
            teksId: topic.teks,
            tapOptions: mapping.map(\.kid)
        )
    }

    // MARK: - T057 Multiplication intro

    private static func t057MultiplicationIntro(topic: Topic, difficulty: Difficulty) -> Problem {
        let rows = Int.random(in: 2...(difficulty == .easy ? 5 : 5))
        let cols = Int.random(in: 2...(difficulty == .easy ? 5 : 9))
        if difficulty == .hard && Bool.random() {
            let product = rows * cols
            return Problem(
                questionText: "\(rows) groups of ___ = \(product). What is the missing factor?",
                visual: .array(rows: rows, cols: cols),
                answerType: .numberEntry,
                correctAnswer: "\(cols)",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "How many in \(rows) groups of \(cols)?",
            visual: .array(rows: rows, cols: cols),
            answerType: .numberEntry,
            correctAnswer: "\(rows * cols)",
            hint: "Multiply rows × columns.",
            teksId: topic.teks
        )
    }

    // MARK: - T058 Venn word problems

    private static func t058VennWordProblems(topic: Topic, difficulty: Difficulty) -> Problem {
        let onlyA = Int.random(in: 3...10)
        let onlyB = Int.random(in: 3...10)
        let both = Int.random(in: 2...6)
        let visual = ProblemVisual.vennDiagram2(onlyA: onlyA, onlyB: onlyB, both: both, labelA: "Cats", labelB: "Dogs")
        if Bool.random() {
            return Problem(
                questionText: "How many like both cats and dogs?",
                visual: visual,
                answerType: .numberEntry,
                correctAnswer: "\(both)",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "How many animals total?",
            visual: visual,
            answerType: .numberEntry,
            correctAnswer: "\(onlyA + onlyB + both)",
            teksId: topic.teks
        )
    }

    // MARK: - T059 Multiply one digit

    private static func t059MultiplyOneDigit(topic: Topic, difficulty: Difficulty) -> Problem {
        let multiplier = Int.random(in: 2...(difficulty == .easy ? 5 : 9))
        let n = Int.random(in: range(for: difficulty, easy: 10..<30, medium: 20..<100, hard: 100...400))
        return Problem(
            questionText: "What is \(n) × \(multiplier)?",
            answerType: .numberEntry,
            correctAnswer: "\(n * multiplier)",
            hint: "Multiply ones first, then regroup.",
            teksId: topic.teks
        )
    }

    // MARK: - Helpers

    private static func fallback(topic: Topic, difficulty: Difficulty) -> Problem {
        Problem(
            questionText: "What is 2 + 2?",
            answerType: .numberEntry,
            correctAnswer: "4",
            teksId: topic.teks
        )
    }

    private static func range(for difficulty: Difficulty, easy: Range<Int>, medium: Range<Int>, hard: ClosedRange<Int>) -> ClosedRange<Int> {
        switch difficulty {
        case .easy: return easy.lowerBound...(easy.upperBound - 1)
        case .medium: return medium.lowerBound...(medium.upperBound - 1)
        case .hard: return hard
        }
    }

    private static func additionPair(difficulty: Difficulty, digits: Int) -> (Int, Int) {
        let cap = Int(pow(10.0, Double(digits)))
        switch difficulty {
        case .easy:
            let a = Int.random(in: cap / 10..<cap / 2)
            let b = Int.random(in: cap / 10..<(cap / 2 - a % 10))
            return (a, b)
        case .medium, .hard:
            return (Int.random(in: cap / 10..<cap), Int.random(in: cap / 20..<cap / 2))
        }
    }

    private static func subtractionPair(difficulty: Difficulty, digits: Int) -> (Int, Int) {
        let cap = Int(pow(10.0, Double(digits)))
        let a = Int.random(in: cap / 2..<cap)
        let b = Int.random(in: cap / 10..<a)
        return (a, b)
    }

    private static func formattedNumber(_ n: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: n)) ?? "\(n)"
    }

    private static func coinSet(difficulty: Difficulty) -> [CoinType] {
        var coins: [CoinType] = []
        let count = difficulty == .easy ? Int.random(in: 2...4) : Int.random(in: 3...6)
        let pool: [CoinType] = difficulty == .hard
            ? [.penny, .nickel, .dime, .quarter]
            : [.penny, .nickel, .dime]
        for _ in 0..<count { coins.append(pool.randomElement() ?? .penny) }
        return coins
    }

    private static func frogDays(depth: Int, climb: Int, slip: Int) -> Int {
        if climb >= depth { return 1 }
        var pos = 0
        var day = 0
        while pos < depth {
            day += 1
            pos += climb
            if pos >= depth { break }
            pos -= slip
        }
        return day
    }
}

/// Shared math helpers used by POT2 and core generators.
enum MathProblemHelpers {
    static func formatTime(hour: Int, minute: Int) -> String {
        String(format: "%d:%02d", hour, minute)
    }

    static func formatCents(_ cents: Int) -> String {
        if cents % 100 == 0 { return "$\(cents / 100).00" }
        return String(format: "$%d.%02d", cents / 100, cents % 100)
    }

    static func multipleChoiceOptions(correct: String, distractors: [String]) -> [String] {
        Array(Set([correct] + distractors)).shuffled()
    }
}
