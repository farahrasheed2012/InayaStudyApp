import Foundation

enum ProblemGenerator {
    static func generate(topic: Topic, difficulty: Difficulty) -> Problem {
        if topic.subject == .science {
            return ScienceProblemGenerator.generate(topic: topic, difficulty: difficulty)
        }

        if topic.id == "staar-mixed" {
            let pool = TopicRegistry.thirdGradePracticeTopics
            let randomTopic = pool.randomElement() ?? topic
            return generate(topic: randomTopic, difficulty: difficulty)
        }

        switch topic.id {
        case "place-value-1200": return placeValue(topic: topic, difficulty: difficulty)
        case "compare-order": return compareOrder(topic: topic, difficulty: difficulty)
        case "add-sub-1000": return addSub1000(topic: topic, difficulty: difficulty)
        case "skip-counting": return skipCounting(topic: topic, difficulty: difficulty)
        case "even-odd": return evenOdd(topic: topic, difficulty: difficulty)
        case "fractions-basic": return fractionsBasic(topic: topic, difficulty: difficulty)
        case "time-minutes": return timeMinutes(topic: topic, difficulty: difficulty)
        case "money-coins": return moneyCoins(topic: topic, difficulty: difficulty)
        case "measurement-length": return measurementLength(topic: topic, difficulty: difficulty)
        case "multiplication": return multiplication(topic: topic, difficulty: difficulty)
        case "division": return division(topic: topic, difficulty: difficulty)
        case "arrays-area-model": return arraysAreaModel(topic: topic, difficulty: difficulty)
        case "fractions-number-line": return fractionsNumberLine(topic: topic, difficulty: difficulty)
        case "compare-fractions": return compareFractions(topic: topic, difficulty: difficulty)
        case "elapsed-time": return elapsedTime(topic: topic, difficulty: difficulty)
        case "perimeter-area": return perimeterArea(topic: topic, difficulty: difficulty)
        case "data-graphs": return dataGraphs(topic: topic, difficulty: difficulty)
        case "money-word-problems": return moneyWordProblems(topic: topic, difficulty: difficulty)
        default:
            return multiplication(topic: topic, difficulty: difficulty)
        }
    }

    // MARK: - 2nd Grade

    private static func placeValue(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 10..<200, medium: 200..<800, hard: 800...1200))
        let hundreds = n / 100
        let tens = (n % 100) / 10
        let ones = n % 10
        let variant = Int.random(in: 0...2)
        switch variant {
        case 0:
            return Problem(
                questionText: "How many hundreds are in \(n)?",
                answerType: .numberEntry,
                correctAnswer: "\(hundreds)",
                hint: "Look at the first digit from the left.",
                teksId: topic.teks
            )
        case 1:
            return Problem(
                questionText: "How many tens are in \(n)?",
                answerType: .numberEntry,
                correctAnswer: "\(tens)",
                hint: "The tens digit is in the middle.",
                teksId: topic.teks
            )
        default:
            let expanded = [hundreds, tens, ones].filter { $0 > 0 || n < 100 }.enumerated().map { i, v in
                let place = ["hundreds", "tens", "ones"][i + (n < 100 ? 1 : 0)]
                return "\(v) \(place)"
            }.joined(separator: " + ")
            return Problem(
                questionText: "What is the expanded form of \(n)? (Example: 300 + 40 + 5)",
                answerType: .multipleChoice,
                correctAnswer: "\(hundreds * 100) + \(tens * 10) + \(ones)",
                choices: multipleChoiceOptions(correct: "\(hundreds * 100) + \(tens * 10) + \(ones)", distractors: [
                    "\(hundreds) + \(tens) + \(ones)",
                    "\(hundreds * 100) + \(ones)",
                    "\(tens * 10) + \(ones)"
                ]),
                hint: "Break the number into hundreds, tens, and ones.",
                teksId: topic.teks
            )
        }
    }

    private static func compareOrder(topic: Topic, difficulty: Difficulty) -> Problem {
        let valueRange = range(for: difficulty, easy: 10..<100, medium: 100..<1000, hard: 100...1199)
        let a = randomInt(in: valueRange)
        var b = randomInt(in: valueRange)
        while b == a { b = randomInt(in: valueRange) }
        if Bool.random() {
            let symbol = a > b ? ">" : a < b ? "<" : "="
            return Problem(
                questionText: "Compare: \(a) ___ \(b). Which symbol goes in the blank?",
                answerType: .tapSelection,
                correctAnswer: symbol,
                hint: "Greater number → open side of > points to it.",
                teksId: topic.teks,
                tapOptions: [">", "<", "="]
            )
        }
        let c = randomInt(in: valueRange)
        let ordered = [a, b, c].sorted()
        return Problem(
            questionText: "Order from least to greatest: \(a), \(b), \(c)",
            answerType: .multipleChoice,
            correctAnswer: ordered.map(String.init).joined(separator: ", "),
            choices: multipleChoiceOptions(correct: ordered.map(String.init).joined(separator: ", "), distractors: [
                [a, c, b].map(String.init).joined(separator: ", "),
                [b, a, c].map(String.init).joined(separator: ", "),
                [c, b, a].map(String.init).joined(separator: ", ")
            ]),
            teksId: topic.teks
        )
    }

    private static func addSub1000(topic: Topic, difficulty: Difficulty) -> Problem {
        let add = Bool.random()
        if add {
            let (a, b) = additionPair(difficulty: difficulty)
            return Problem(
                questionText: "What is \(a) + \(b)?",
                answerType: .numberEntry,
                correctAnswer: "\(a + b)",
                hint: "Line up ones, tens, and hundreds.",
                teksId: topic.teks
            )
        }
        let (minuend, subtrahend) = subtractionPair(difficulty: difficulty)
        return Problem(
            questionText: "What is \(minuend) − \(subtrahend)?",
            answerType: .numberEntry,
            correctAnswer: "\(minuend - subtrahend)",
            hint: "Subtract ones first, then tens, then hundreds.",
            teksId: topic.teks
        )
    }

    private static func skipCounting(topic: Topic, difficulty: Difficulty) -> Problem {
        let step: Int
        switch difficulty {
        case .easy: step = [2, 5].randomElement()!
        case .medium: step = [10, 100].randomElement()!
        case .hard: step = [2, 5, 10, 100].randomElement()!
        }
        let start = difficulty == .hard ? randomInt(in: step..<(step * 8)) : 0
        var seq = (0..<5).map { start + $0 * step }
        let blankIndex = Int.random(in: 1..<4)
        let answer = seq[blankIndex]
        seq[blankIndex] = -1
        let display = seq.map { $0 < 0 ? "?" : "\($0)" }.joined(separator: ", ")
        return Problem(
            questionText: "Skip count by \(step)s: \(display)",
            answerType: .numberEntry,
            correctAnswer: "\(answer)",
            hint: "Add \(step) each time.",
            teksId: topic.teks
        )
    }

    private static func evenOdd(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 1..<10, medium: 10..<100, hard: 100...999))
        let answer = n % 2 == 0 ? "Even" : "Odd"
        return Problem(
            questionText: "Is \(n) even or odd?",
            answerType: .tapSelection,
            correctAnswer: answer,
            hint: "Even numbers end in 0, 2, 4, 6, or 8.",
            teksId: topic.teks,
            tapOptions: ["Even", "Odd"]
        )
    }

    private static func fractionsBasic(topic: Topic, difficulty: Difficulty) -> Problem {
        let denom = [2, 4, 8].randomElement()!
        let num = Int.random(in: 1..<denom)
        return Problem(
            questionText: "What fraction of the circle is shaded?",
            visual: .fractionCircle(numerator: num, denominator: denom),
            answerType: .multipleChoice,
            correctAnswer: "\(num)/\(denom)",
            choices: multipleChoiceOptions(correct: "\(num)/\(denom)", distractors: Array([
                "\(num)/\(denom * 2)",
                "\(denom - num)/\(denom)",
                "\(num + 1)/\(denom)"
            ].filter { $0 != "\(num)/\(denom)" }.prefix(3))),
            teksId: topic.teks
        )
    }

    private static func timeMinutes(topic: Topic, difficulty: Difficulty) -> Problem {
        let hour = Int.random(in: 1...12)
        let minute: Int
        switch difficulty {
        case .easy: minute = 0
        case .medium: minute = [0, 15, 30, 45].randomElement()!
        case .hard: minute = Int.random(in: 0...11) * 5
        }
        return Problem(
            questionText: "What time does the clock show?",
            visual: .clockFace(hour: hour, minute: minute),
            answerType: .multipleChoice,
            correctAnswer: formatTime(hour: hour, minute: minute),
            choices: multipleChoiceOptions(correct: formatTime(hour: hour, minute: minute), distractors: [
                formatTime(hour: hour, minute: (minute + 5) % 60),
                formatTime(hour: (hour % 12) + 1, minute: minute),
                formatTime(hour: hour, minute: (minute + 15) % 60)
            ]),
            teksId: topic.teks
        )
    }

    private static func moneyCoins(topic: Topic, difficulty: Difficulty) -> Problem {
        let coins = coinSet(difficulty: difficulty)
        let total = coins.reduce(0) { $0 + $1.cents }
        return Problem(
            questionText: "How much money is shown?",
            visual: .coins(coins),
            answerType: .numberEntry,
            correctAnswer: formatCents(total),
            hint: "Add the value of each coin.",
            teksId: topic.teks
        )
    }

    private static func measurementLength(topic: Topic, difficulty: Difficulty) -> Problem {
        let a = randomInt(in: range(for: difficulty, easy: 1..<12, medium: 12..<36, hard: 36...99))
        let b = randomInt(in: range(for: difficulty, easy: 1..<12, medium: 12..<36, hard: 36...99))
        if Bool.random() {
            let longer = max(a, b)
            return Problem(
                questionText: "Ruler A is \(a) inches. Ruler B is \(b) inches. How much longer is the longer ruler?",
                answerType: .numberEntry,
                correctAnswer: "\(abs(a - b))",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "A ribbon is \(a) inches long. You cut off \(b) inches. How many inches are left?",
            answerType: .numberEntry,
            correctAnswer: "\(max(0, a - b))",
            teksId: topic.teks
        )
    }

    // MARK: - 3rd Grade

    private static func multiplication(topic: Topic, difficulty: Difficulty) -> Problem {
        let tables = timesTables(for: difficulty)
        let a = tables.randomElement()!
        let b = Int.random(in: 0...12)
        return Problem(
            questionText: "What is \(a) × \(b)?",
            answerType: .numberEntry,
            correctAnswer: "\(a * b)",
            teksId: topic.teks
        )
    }

    private static func division(topic: Topic, difficulty: Difficulty) -> Problem {
        let tables = timesTables(for: difficulty)
        let divisor = tables.randomElement()!
        let quotient = Int.random(in: 1...12)
        let dividend = divisor * quotient
        return Problem(
            questionText: "What is \(dividend) ÷ \(divisor)?",
            answerType: .numberEntry,
            correctAnswer: "\(quotient)",
            teksId: topic.teks
        )
    }

    private static func arraysAreaModel(topic: Topic, difficulty: Difficulty) -> Problem {
        let maxSide = difficulty == .easy ? 5 : difficulty == .medium ? 8 : 10
        let rows = Int.random(in: 2...maxSide)
        let cols = Int.random(in: 2...maxSide)
        let product = rows * cols
        if difficulty == .hard && Bool.random() {
            return Problem(
                questionText: "An array has \(rows) rows. Each row has \(cols) squares. How many squares in all?",
                visual: .array(rows: rows, cols: cols),
                answerType: .numberEntry,
                correctAnswer: "\(product)",
                teksId: topic.teks
            )
        }
        if Bool.random() {
            return Problem(
                questionText: "How many rows are in this array?",
                visual: .array(rows: rows, cols: cols),
                answerType: .numberEntry,
                correctAnswer: "\(rows)",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "What is \(rows) × \(cols)?",
            visual: .array(rows: rows, cols: cols),
            answerType: .numberEntry,
            correctAnswer: "\(product)",
            teksId: topic.teks
        )
    }

    private static func fractionsNumberLine(topic: Topic, difficulty: Difficulty) -> Problem {
        let denom = [2, 3, 4, 6, 8].randomElement()!
        let num = Int.random(in: 1..<denom)
        let marker = num * (100 / denom)
        return Problem(
            questionText: "What fraction is at the point on the number line from 0 to 1?",
            visual: .numberLine(min: 0, max: 100, marked: [marker]),
            answerType: .multipleChoice,
            correctAnswer: "\(num)/\(denom)",
            choices: multipleChoiceOptions(correct: "\(num)/\(denom)", distractors: Array([
                "\(num)/\(denom * 2)",
                "\(num + 1)/\(denom)",
                "\(denom - num)/\(denom)"
            ].filter { $0 != "\(num)/\(denom)" }.prefix(3))),
            teksId: topic.teks
        )
    }

    private static func compareFractions(topic: Topic, difficulty: Difficulty) -> Problem {
        let (f1, f2, greater): ((Int, Int), (Int, Int), String)
        switch difficulty {
        case .easy:
            let d = [2, 4, 8].randomElement()!
            let n1 = Int.random(in: 1..<d)
            var n2 = Int.random(in: 1..<d)
            while n2 == n1 { n2 = Int.random(in: 1..<d) }
            f1 = (n1, d); f2 = (n2, d)
            greater = n1 > n2 ? "\(n1)/\(d)" : "\(n2)/\(d)"
        case .medium:
            let n = Int.random(in: 1...3)
            let d1 = [2, 4, 8].randomElement()!
            let d2 = [2, 4, 8].randomElement()!
            f1 = (n, d1); f2 = (n, d2)
            greater = d1 < d2 ? "\(n)/\(d1)" : "\(n)/\(d2)"
        default:
            f1 = (Int.random(in: 1...3), [4, 6, 8].randomElement()!)
            f2 = (Int.random(in: 1...3), [4, 6, 8].randomElement()!)
            let v1 = Double(f1.0) / Double(f1.1)
            let v2 = Double(f2.0) / Double(f2.1)
            greater = v1 > v2 ? "\(f1.0)/\(f1.1)" : "\(f2.0)/\(f2.1)"
        }
        return Problem(
            questionText: "Which fraction is greater: \(f1.0)/\(f1.1) or \(f2.0)/\(f2.1)?",
            answerType: .tapSelection,
            correctAnswer: greater,
            hint: "Same denominator → bigger numerator wins.",
            teksId: topic.teks,
            tapOptions: ["\(f1.0)/\(f1.1)", "\(f2.0)/\(f2.1)"]
        )
    }

    private static func elapsedTime(topic: Topic, difficulty: Difficulty) -> Problem {
        let startH = Int.random(in: 1...11)
        let startM: Int
        let durationM: Int
        switch difficulty {
        case .easy:
            startM = 0; durationM = Int.random(in: 1...4) * 60
        case .medium:
            startM = [0, 30].randomElement()!
            durationM = Int.random(in: 1...3) * 30
        default:
            startM = Int.random(in: 0...11) * 5
            durationM = Int.random(in: 1...6) * 5
        }
        let totalStart = startH * 60 + startM
        let endTotal = totalStart + durationM
        let endH = (endTotal / 60) % 12 == 0 ? 12 : (endTotal / 60) % 12
        let endM = endTotal % 60
        if Bool.random() {
            return Problem(
                questionText: "Start: \(formatTime(hour: startH, minute: startM)). End: \(formatTime(hour: endH, minute: endM)). How many minutes passed?",
                answerType: .numberEntry,
                correctAnswer: "\(durationM)",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "Start: \(formatTime(hour: startH, minute: startM)). Elapsed: \(durationM) minutes. What time did it end?",
            answerType: .multipleChoice,
            correctAnswer: formatTime(hour: endH, minute: endM),
            choices: multipleChoiceOptions(correct: formatTime(hour: endH, minute: endM), distractors: [
                formatTime(hour: startH, minute: (startM + 15) % 60),
                formatTime(hour: (startH % 12) + 1, minute: startM),
                formatTime(hour: endH, minute: (endM + 10) % 60)
            ]),
            teksId: topic.teks
        )
    }

    private static func perimeterArea(topic: Topic, difficulty: Difficulty) -> Problem {
        let w = randomInt(in: range(for: difficulty, easy: 2..<6, medium: 6..<12, hard: 10...19))
        let h = randomInt(in: range(for: difficulty, easy: 2..<6, medium: 6..<12, hard: 10...19))
        let askArea = Bool.random()
        if difficulty == .hard && !askArea {
            let perimeter = 2 * (w + h)
            return Problem(
                questionText: "A rectangle has perimeter \(perimeter) units and width \(w). What is the length?",
                visual: .rectangle(width: w, height: h),
                answerType: .numberEntry,
                correctAnswer: "\(h)",
                teksId: topic.teks
            )
        }
        if askArea {
            return Problem(
                questionText: "What is the area of this rectangle? (length × width)",
                visual: .rectangle(width: w, height: h),
                answerType: .numberEntry,
                correctAnswer: "\(w * h)",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "What is the perimeter of this rectangle?",
            visual: .rectangle(width: w, height: h),
            answerType: .numberEntry,
            correctAnswer: "\(2 * (w + h))",
            hint: "Add all four sides.",
            teksId: topic.teks
        )
    }

    private static func dataGraphs(topic: Topic, difficulty: Difficulty) -> Problem {
        let labels = ["Red", "Blue", "Green", "Yellow", "Purple"].shuffled().prefix(Int.random(in: 3...5))
        let data = labels.map { ($0, randomInt(in: 2..<12)) }
        let sorted = data.sorted { $0.1 > $1.1 }
        let variant = Int.random(in: 0...2)
        switch variant {
        case 0:
            return Problem(
                questionText: "Which category has the most?",
                visual: .barGraph(data: data),
                answerType: .tapSelection,
                correctAnswer: sorted[0].0,
                teksId: topic.teks,
                tapOptions: data.map(\.0)
            )
        case 1:
            let a = data[0], b = data[1]
            return Problem(
                questionText: "How many more \(a.0) than \(b.0)?",
                visual: .barGraph(data: data),
                answerType: .numberEntry,
                correctAnswer: "\(abs(a.1 - b.1))",
                teksId: topic.teks
            )
        default:
            let total = data.reduce(0) { $0 + $1.1 }
            return Problem(
                questionText: "What is the total of all categories?",
                visual: .barGraph(data: data),
                answerType: .numberEntry,
                correctAnswer: "\(total)",
                teksId: topic.teks
            )
        }
    }

    private static func moneyWordProblems(topic: Topic, difficulty: Difficulty) -> Problem {
        let price1 = priceCents(difficulty: difficulty)
        var price2 = priceCents(difficulty: difficulty)
        if difficulty == .easy { price2 = 0 }
        let total = price1 + price2
        let paid = ((total + 99) / 100) * 100
        if price2 == 0 {
            return Problem(
                questionText: "Inaya buys a snack for \(formatCents(price1)). She pays with \(formatCents(paid)). How much change?",
                answerType: .numberEntry,
                correctAnswer: formatCents(paid - total),
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "Inaya buys items for \(formatCents(price1)) and \(formatCents(price2)). What is the total cost?",
            answerType: .numberEntry,
            correctAnswer: formatCents(total),
            teksId: topic.teks
        )
    }

    // MARK: - Helpers

    private static func randomInt(in range: Range<Int>) -> Int {
        Int.random(in: range)
    }

    private static func randomInt(in range: ClosedRange<Int>) -> Int {
        Int.random(in: range)
    }

    private static func range(for difficulty: Difficulty, easy: Range<Int>, medium: Range<Int>, hard: ClosedRange<Int>) -> ClosedRange<Int> {
        switch difficulty {
        case .easy: return easy.lowerBound...(easy.upperBound - 1)
        case .medium: return medium.lowerBound...(medium.upperBound - 1)
        case .hard: return hard
        }
    }

    static func multipleChoiceOptions(correct: String, distractors: [String]) -> [String] {
        Array(Set([correct] + distractors)).shuffled()
    }

    private static func additionPair(difficulty: Difficulty) -> (Int, Int) {
        switch difficulty {
        case .easy:
            let a = Int.random(in: 10..<90)
            let b = Int.random(in: 10..<(100 - a))
            return (a, b)
        case .medium:
            return (Int.random(in: 100..<500), Int.random(in: 50..<300))
        case .hard:
            return (Int.random(in: 400..<800), Int.random(in: 100..<400))
        }
    }

    private static func subtractionPair(difficulty: Difficulty) -> (Int, Int) {
        switch difficulty {
        case .easy:
            let a = Int.random(in: 20..<100)
            let b = Int.random(in: 10..<a)
            return (a, b)
        case .medium:
            let a = Int.random(in: 200..<800)
            let b = Int.random(in: 50..<a)
            return (a, b)
        case .hard:
            let a = Int.random(in: 500..<1000)
            let b = Int.random(in: 100..<a)
            return (a, b)
        }
    }

    private static func timesTables(for difficulty: Difficulty) -> [Int] {
        switch difficulty {
        case .easy: return [0, 1, 2, 5]
        case .medium: return [3, 4, 6, 10]
        case .hard: return [7, 8, 9, 11, 12]
        }
    }

    private static func coinSet(difficulty: Difficulty) -> [CoinType] {
        var coins: [CoinType] = []
        let count: Int
        switch difficulty {
        case .easy: count = Int.random(in: 2...4)
        case .medium: count = Int.random(in: 3...6)
        case .hard: count = Int.random(in: 4...8)
        }
        let pool: [CoinType] = difficulty == .hard
            ? [.penny, .nickel, .dime, .quarter, .dollar]
            : [.penny, .nickel, .dime, .quarter]
        for _ in 0..<count {
            coins.append(pool.randomElement()!)
        }
        return coins
    }

    private static func priceCents(difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy: return Int.random(in: 1...5) * 100
        case .medium: return Int.random(in: 2...8) * 25
        case .hard: return Int.random(in: 50...350)
        }
    }

    static func formatTime(hour: Int, minute: Int) -> String {
        let h = hour == 0 ? 12 : hour
        let m = minute == 0 ? "00" : String(format: "%02d", minute)
        return "\(h):\(m)"
    }

    static func formatCents(_ cents: Int) -> String {
        if cents % 100 == 0 { return "$\(cents / 100)" }
        return String(format: "$%.2f", Double(cents) / 100.0)
    }

    /// Validates a generated problem's answer (for tests).
    static func isAnswerValid(_ problem: Problem, userAnswer: String) -> Bool {
        normalize(userAnswer) == normalize(problem.correctAnswer)
    }

    static func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}
