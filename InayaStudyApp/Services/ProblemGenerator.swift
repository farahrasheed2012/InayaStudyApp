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

        if topic.id == "staar-mixed-2" {
            let pool = TopicRegistry.secondGradePracticeTopics
            let randomTopic = pool.randomElement() ?? topic
            return generate(topic: randomTopic, difficulty: difficulty)
        }

        if topic.id == "pot-mixed-catchup-2" {
            let pool = TopicRegistry.potCatchUpPracticeTopics
            let randomTopic = pool.randomElement() ?? topic
            return generate(topic: randomTopic, difficulty: difficulty)
        }

        if topic.potCode != nil {
            return POT2ProblemGenerator.generate(topic: topic, difficulty: difficulty)
        }

        switch topic.id {
        case "place-value-1200": return placeValue(topic: topic, difficulty: difficulty)
        case "compose-decompose": return composeDecompose(topic: topic, difficulty: difficulty)
        case "compare-order": return compareOrder(topic: topic, difficulty: difficulty)
        case "number-word-form": return numberWordForm(topic: topic, difficulty: difficulty)
        case "more-or-less-100": return moreOrLess100(topic: topic, difficulty: difficulty)
        case "number-line-1200": return numberLine1200(topic: topic, difficulty: difficulty)
        case "facts-to-100": return factsTo100(topic: topic, difficulty: difficulty)
        case "add-sub-1000": return addSub1000(topic: topic, difficulty: difficulty)
        case "word-problems-addsub-2": return wordProblemsAddSub2(topic: topic, difficulty: difficulty)
        case "skip-counting": return skipCounting(topic: topic, difficulty: difficulty)
        case "even-odd": return evenOdd(topic: topic, difficulty: difficulty)
        case "fractions-basic": return fractionsBasic(topic: topic, difficulty: difficulty)
        case "fraction-models": return fractionModels(topic: topic, difficulty: difficulty)
        case "arrays-groups-2": return arraysGroups2(topic: topic, difficulty: difficulty)
        case "equal-sharing-2": return equalSharing2(topic: topic, difficulty: difficulty)
        case "area-square-units-2": return areaSquareUnits2(topic: topic, difficulty: difficulty)
        case "shapes-2d-3d": return shapes2D3D(topic: topic, difficulty: difficulty)
        case "graphs-data-2": return graphsData2(topic: topic, difficulty: difficulty)
        case "time-minutes": return timeMinutes(topic: topic, difficulty: difficulty)
        case "money-coins": return moneyCoins(topic: topic, difficulty: difficulty)
        case "financial-literacy-2": return financialLiteracy2(topic: topic, difficulty: difficulty)
        case "measurement-length": return measurementLength(topic: topic, difficulty: difficulty)
        case "measurement-metric-2": return measurementMetric2(topic: topic, difficulty: difficulty)
        case "measurement-wct": return measurementWCT(topic: topic, difficulty: difficulty)
        case "place-value-100k": return placeValue100k(topic: topic, difficulty: difficulty)
        case "estimation-rounding": return estimationRounding(topic: topic, difficulty: difficulty)
        case "add-sub-1000-3": return addSub1000(topic: topic, difficulty: difficulty)
        case "two-step-word-problems": return twoStepWordProblems(topic: topic, difficulty: difficulty)
        case "unit-fractions": return unitFractions(topic: topic, difficulty: difficulty)
        case "equivalent-fractions": return equivalentFractions(topic: topic, difficulty: difficulty)
        case "shapes-quadrilaterals": return shapesQuadrilaterals(topic: topic, difficulty: difficulty)
        case "multiplication": return multiplication(topic: topic, difficulty: difficulty)
        case "division": return division(topic: topic, difficulty: difficulty)
        case "even-odd-3": return evenOdd3(topic: topic, difficulty: difficulty)
        case "number-patterns-3": return numberPatterns3(topic: topic, difficulty: difficulty)
        case "arrays-area-model": return arraysAreaModel(topic: topic, difficulty: difficulty)
        case "fractions-number-line": return fractionsNumberLine(topic: topic, difficulty: difficulty)
        case "compare-fractions": return compareFractions(topic: topic, difficulty: difficulty)
        case "elapsed-time": return elapsedTime(topic: topic, difficulty: difficulty)
        case "perimeter-area": return perimeterArea(topic: topic, difficulty: difficulty)
        case "shapes-3d-3": return shapes3D3(topic: topic, difficulty: difficulty)
        case "geo-measure-word-problems-3": return geoMeasureWordProblems3(topic: topic, difficulty: difficulty)
        case "measurement-units-3": return measurementUnits3(topic: topic, difficulty: difficulty)
        case "data-graphs": return dataGraphs(topic: topic, difficulty: difficulty)
        case "money-word-problems": return moneyWordProblems(topic: topic, difficulty: difficulty)
        case "financial-literacy-3": return financialLiteracy3(topic: topic, difficulty: difficulty)
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
            let d = [4, 8].randomElement()!
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

    // MARK: - Extended 2nd Grade

    private static func composeDecompose(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 24..<200, medium: 200..<800, hard: 800...1200))
        let hundreds = n / 100
        let tens = (n % 100) / 10
        let ones = n % 10
        if Bool.random() {
            return Problem(
                questionText: "What is \(n) in expanded form?",
                answerType: .multipleChoice,
                correctAnswer: "\(hundreds * 100) + \(tens * 10) + \(ones)",
                choices: multipleChoiceOptions(correct: "\(hundreds * 100) + \(tens * 10) + \(ones)", distractors: [
                    "\(hundreds) + \(tens) + \(ones)",
                    "\(hundreds * 100) + \(ones)",
                    "\(tens * 10) + \(ones)"
                ]),
                hint: "Break into hundreds, tens, and ones.",
                teksId: topic.teks
            )
        }
        let parts = [hundreds * 100, tens * 10, ones].filter { $0 > 0 }
        let sum = parts.reduce(0, +)
        return Problem(
            questionText: "What number is \(parts.map(String.init).joined(separator: " + "))?",
            answerType: .numberEntry,
            correctAnswer: "\(sum)",
            hint: "Add the parts together.",
            teksId: topic.teks
        )
    }

    private static func wordProblemsAddSub2(topic: Topic, difficulty: Difficulty) -> Problem {
        let names = ["Inaya", "Maya", "Sam", "Zoe"]
        let name = names.randomElement()!
        if Bool.random() {
            let (a, b) = additionPair(difficulty: difficulty)
            let items = ["stickers", "marbles", "books", "crayons"]
            let item = items.randomElement()!
            return Problem(
                questionText: "\(name) has \(a) \(item). She gets \(b) more. How many \(item) does she have now?",
                answerType: .numberEntry,
                correctAnswer: "\(a + b)",
                hint: "Add to find the total.",
                teksId: topic.teks
            )
        }
        let (minuend, subtrahend) = subtractionPair(difficulty: difficulty)
        let items = ["apples", "toys", "pages", "coins"]
        let item = items.randomElement()!
        return Problem(
            questionText: "\(name) had \(minuend) \(item). She gave away \(subtrahend). How many are left?",
            answerType: .numberEntry,
            correctAnswer: "\(minuend - subtrahend)",
            hint: "Subtract to find what's left.",
            teksId: topic.teks
        )
    }

    private static func fractionModels(topic: Topic, difficulty: Difficulty) -> Problem {
        fractionsBasic(topic: topic, difficulty: difficulty)
    }

    private static func arraysGroups2(topic: Topic, difficulty: Difficulty) -> Problem {
        let rows = Int.random(in: 2...(difficulty == .easy ? 4 : 5))
        let cols = Int.random(in: 2...(difficulty == .hard ? 6 : 4))
        let total = rows * cols
        if Bool.random() {
            return Problem(
                questionText: "There are \(rows) equal groups with \(cols) in each group. How many in all?",
                visual: .array(rows: rows, cols: cols),
                answerType: .numberEntry,
                correctAnswer: "\(total)",
                hint: "Multiply groups × items in each group.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "How many squares are in this array?",
            visual: .array(rows: rows, cols: cols),
            answerType: .numberEntry,
            correctAnswer: "\(total)",
            teksId: topic.teks
        )
    }

    private static func shapes2D3D(topic: Topic, difficulty: Difficulty) -> Problem {
        let shapes2d = [("triangle", "3 sides"), ("square", "4 equal sides"), ("rectangle", "4 sides"), ("circle", "no corners")]
        let shapes3d = [("cube", "6 square faces"), ("sphere", "round like a ball"), ("cylinder", "can shape"), ("cone", "ice cream cone shape")]
        if difficulty == .easy || Bool.random() {
            let s = shapes2d.randomElement()!
            return Problem(
                questionText: "How many sides does a \(s.0) have?",
                answerType: .multipleChoice,
                correctAnswer: s.0 == "circle" ? "0" : (s.0 == "triangle" ? "3" : "4"),
                choices: multipleChoiceOptions(correct: s.0 == "circle" ? "0" : (s.0 == "triangle" ? "3" : "4"), distractors: ["2", "5", "6"]),
                hint: s.1,
                teksId: topic.teks
            )
        }
        let s = shapes3d.randomElement()!
        return Problem(
            questionText: "Which 3D shape is described: \(s.1)?",
            answerType: .tapSelection,
            correctAnswer: s.0,
            hint: "Think about real objects with this shape.",
            teksId: topic.teks,
            tapOptions: shapes3d.map(\.0)
        )
    }

    private static func graphsData2(topic: Topic, difficulty: Difficulty) -> Problem {
        dataGraphs(topic: topic, difficulty: difficulty)
    }

    private static func measurementWCT(topic: Topic, difficulty: Difficulty) -> Problem {
        let variant = Int.random(in: 0...2)
        switch variant {
        case 0:
            let lbs = randomInt(in: range(for: difficulty, easy: 1..<10, medium: 10..<50, hard: 50...200))
            return Problem(
                questionText: "A backpack weighs \(lbs) pounds. Which unit did we use?",
                answerType: .tapSelection,
                correctAnswer: "pounds",
                hint: "Weight uses pounds or ounces.",
                teksId: topic.teks,
                tapOptions: ["pounds", "liters", "degrees"]
            )
        case 1:
            let cups = randomInt(in: 2...8)
            return Problem(
                questionText: "A jug holds \(cups) cups of water. This measures ___",
                answerType: .tapSelection,
                correctAnswer: "capacity",
                hint: "How much a container holds is capacity.",
                teksId: topic.teks,
                tapOptions: ["capacity", "length", "temperature"]
            )
        default:
            let temp = randomInt(in: range(for: difficulty, easy: 60..<80, medium: 32..<100, hard: 0...120))
            return Problem(
                questionText: "The thermometer shows \(temp)°F. What does it measure?",
                answerType: .tapSelection,
                correctAnswer: "temperature",
                teksId: topic.teks,
                tapOptions: ["temperature", "weight", "length"]
            )
        }
    }

    private static func factsTo100(topic: Topic, difficulty: Difficulty) -> Problem {
        if Bool.random() {
            let a = Int.random(in: 1...(difficulty == .easy ? 40 : 60))
            let b = Int.random(in: 1...(100 - a))
            return Problem(
                questionText: "What is \(a) + \(b)?",
                answerType: .numberEntry,
                correctAnswer: "\(a + b)",
                hint: "Add the two numbers.",
                teksId: topic.teks
            )
        }
        let a = Int.random(in: (difficulty == .easy ? 20 : 40)...(difficulty == .hard ? 99 : 80))
        let b = Int.random(in: 1..<min(a, difficulty == .easy ? 20 : 40))
        return Problem(
            questionText: "What is \(a) − \(b)?",
            answerType: .numberEntry,
            correctAnswer: "\(a - b)",
            hint: "Subtract to find the difference.",
            teksId: topic.teks
        )
    }

    private static func moreOrLess100(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 50..<300, medium: 300..<800, hard: 800...1100))
        let delta = Bool.random() ? (difficulty == .easy ? 10 : (Bool.random() ? 10 : 100)) : (difficulty == .hard ? 100 : 10)
        let more = Bool.random()
        let result = more ? n + delta : n - delta
        let phrase = more ? "\(delta) more than" : "\(delta) less than"
        return Problem(
            questionText: "What is \(phrase) \(n)?",
            answerType: .numberEntry,
            correctAnswer: "\(result)",
            hint: more ? "Add \(delta)." : "Subtract \(delta).",
            teksId: topic.teks
        )
    }

    private static func numberLine1200(topic: Topic, difficulty: Difficulty) -> Problem {
        let step = difficulty == .easy ? 10 : (difficulty == .medium ? 50 : 100)
        let start = (randomInt(in: range(for: difficulty, easy: 0..<200, medium: 200..<600, hard: 600...900)) / step) * step
        let marker = start + step * Int.random(in: 1...4)
        guard marker <= 1200 else {
            return numberLine1200(topic: topic, difficulty: difficulty)
        }
        if Bool.random() {
            return Problem(
                questionText: "On the number line, what number is at the point marked?",
                visual: .numberLine(min: max(0, start - step), max: min(1200, marker + step * 2), marked: [marker]),
                answerType: .numberEntry,
                correctAnswer: "\(marker)",
                hint: "Count by \(step)s from the left.",
                teksId: topic.teks
            )
        }
        let delta = step
        return Problem(
            questionText: "The number line shows \(marker). What is \(delta) more than \(marker)?",
            visual: .numberLine(min: max(0, marker - step), max: min(1200, marker + step * 3), marked: [marker]),
            answerType: .numberEntry,
            correctAnswer: "\(marker + delta)",
            hint: "Start at \(marker) and count forward \(delta).",
            teksId: topic.teks
        )
    }

    private static func numberWordForm(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 11..<100, medium: 100..<500, hard: 500...1200))
        let words = numberToWords(n)
        let wrong = [numberToWords(n + 11), numberToWords(max(11, n - 13)), numberToWords((n / 10) * 10 + 7)]
            .filter { $0 != words }
        if Bool.random() {
            return Problem(
                questionText: "How do you write \(n) in word form?",
                answerType: .multipleChoice,
                correctAnswer: words,
                choices: multipleChoiceOptions(correct: words, distractors: Array(wrong.prefix(3))),
                hint: "Say the number out loud: hundreds, tens, ones.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "What number is \"\(words)\"?",
            answerType: .numberEntry,
            correctAnswer: "\(n)",
            hint: "Break the words into hundreds, tens, and ones.",
            teksId: topic.teks
        )
    }

    private static func equalSharing2(topic: Topic, difficulty: Difficulty) -> Problem {
        let groups = Int.random(in: 2...(difficulty == .easy ? 3 : 5))
        let per = Int.random(in: 2...(difficulty == .hard ? 8 : 5))
        let total = groups * per
        let items = ["cookies", "stickers", "marbles", "pencils"]
        let item = items.randomElement()!
        if Bool.random() {
            return Problem(
                questionText: "\(total) \(item) are shared equally among \(groups) friends. How many does each friend get?",
                answerType: .numberEntry,
                correctAnswer: "\(per)",
                hint: "Divide the total into equal groups.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "Each of \(groups) bags has \(per) \(item). How many \(item) in all?",
            answerType: .numberEntry,
            correctAnswer: "\(total)",
            hint: "Multiply groups × items in each group.",
            teksId: topic.teks
        )
    }

    private static func areaSquareUnits2(topic: Topic, difficulty: Difficulty) -> Problem {
        let w = randomInt(in: range(for: difficulty, easy: 2..<5, medium: 4..<8, hard: 6...10))
        let h = randomInt(in: range(for: difficulty, easy: 2..<5, medium: 4..<8, hard: 6...10))
        if Bool.random() {
            return Problem(
                questionText: "Count the square units. What is the area of this rectangle?",
                visual: .rectangle(width: w, height: h),
                answerType: .numberEntry,
                correctAnswer: "\(w * h)",
                hint: "Area = rows × columns of square units. No gaps or overlaps!",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "A rectangle is \(w) square units long and \(h) square units wide. What is its area?",
            visual: .rectangle(width: w, height: h),
            answerType: .numberEntry,
            correctAnswer: "\(w * h)",
            hint: "Multiply length × width.",
            teksId: topic.teks
        )
    }

    private static func financialLiteracy2(topic: Topic, difficulty: Difficulty) -> Problem {
        let scenarios: [(String, String, [String])] = [
            ("Inaya puts $5 in her piggy bank each week. This is called ___", "saving", ["spending", "borrowing", "wasting"]),
            ("Inaya buys a toy with her allowance. This is ___", "spending", ["saving", "depositing", "earning interest"]),
            ("Inaya's mom puts money into the bank account. This is a ___", "deposit", ["withdrawal", "loan", "tax"]),
            ("Inaya takes money out of her savings to buy a book. This is a ___", "withdrawal", ["deposit", "donation", "refund"]),
            ("Why save money instead of spending it all?", "for future needs", ["to throw it away", "because banks are scary", "money disappears"]),
            ("Which is a NEED, not a want?", "healthy food", ["extra candy", "another video game", "fancy shoes"]),
        ]
        let pick = scenarios.randomElement()!
        return Problem(
            questionText: pick.0,
            answerType: .multipleChoice,
            correctAnswer: pick.1,
            choices: multipleChoiceOptions(correct: pick.1, distractors: pick.2),
            hint: "Think about what happens to money when you save or spend.",
            teksId: topic.teks
        )
    }

    private static func measurementMetric2(topic: Topic, difficulty: Difficulty) -> Problem {
        let cm = randomInt(in: range(for: difficulty, easy: 5..<30, medium: 30..<80, hard: 80...150))
        if Bool.random() {
            let meters = difficulty == .easy ? 1 : Int.random(in: 1...3)
            return Problem(
                questionText: "A rope is \(meters) meter\(meters == 1 ? "" : "s") long. How many centimeters is that?",
                answerType: .numberEntry,
                correctAnswer: "\(meters * 100)",
                hint: "1 meter = 100 centimeters.",
                teksId: topic.teks
            )
        }
        if difficulty != .easy && Bool.random() {
            return Problem(
                questionText: "Which tool is best to measure the length of a pencil?",
                answerType: .tapSelection,
                correctAnswer: "centimeter ruler",
                hint: "Small objects use centimeters.",
                teksId: topic.teks,
                tapOptions: ["centimeter ruler", "meter stick", "bathroom scale", "thermometer"]
            )
        }
        return Problem(
            questionText: "A crayon is \(cm) cm long. About how long is it?",
            answerType: .numberEntry,
            correctAnswer: "\(cm)",
            hint: "Centimeters (cm) are good for small lengths.",
            teksId: topic.teks
        )
    }

    private static func numberToWords(_ n: Int) -> String {
        let ones = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        let teens = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
        let tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

        func under100(_ x: Int) -> String {
            if x < 10 { return ones[x] }
            if x < 20 { return teens[x - 10] }
            let t = x / 10
            let o = x % 10
            return o == 0 ? tens[t] : "\(tens[t])-\(ones[o])"
        }

        func under1000(_ x: Int) -> String {
            if x < 100 { return under100(x) }
            let h = x / 100
            let rest = x % 100
            if rest == 0 { return "\(ones[h]) hundred" }
            return "\(ones[h]) hundred \(under100(rest))"
        }

        if n < 1000 { return under1000(n) }
        let th = n / 1000
        let rest = n % 1000
        if rest == 0 { return "\(under1000(th)) thousand" }
        return "\(under1000(th)) thousand \(under1000(rest))"
    }

    // MARK: - Extended 3rd Grade

    private static func placeValue100k(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 1000..<10000, medium: 10000..<50000, hard: 50000...99999))
        let thousands = (n % 10000) / 1000
        if Bool.random() {
            return Problem(
                questionText: "What is the value of the digit \(thousands) in \(n)?",
                answerType: .numberEntry,
                correctAnswer: "\(thousands * 1000)",
                hint: "Thousands place × 1,000.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "How many thousands are in \(n)?",
            answerType: .numberEntry,
            correctAnswer: "\(n / 1000)",
            hint: "Count groups of 1,000.",
            teksId: topic.teks
        )
    }

    private static func estimationRounding(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 20..<200, medium: 200..<2000, hard: 2000...9999))
        let roundTo = difficulty == .easy ? 10 : 100
        let correct = difficulty == .easy
            ? ((n + 5) / 10) * 10
            : ((n + 50) / 100) * 100
        return Problem(
            questionText: "Round \(n) to the nearest \(roundTo == 10 ? "ten" : "hundred").",
            answerType: .numberEntry,
            correctAnswer: "\(correct)",
            hint: "Look at the digit to the right to decide up or down.",
            teksId: topic.teks
        )
    }

    private static func twoStepWordProblems(topic: Topic, difficulty: Difficulty) -> Problem {
        let a = randomInt(in: range(for: difficulty, easy: 5..<20, medium: 20..<100, hard: 100...500))
        let b = randomInt(in: range(for: difficulty, easy: 3..<15, medium: 10..<50, hard: 50...200))
        let c = randomInt(in: range(for: difficulty, easy: 2..<10, medium: 5..<30, hard: 20...100))
        if Bool.random() {
            return Problem(
                questionText: "Inaya has \(a) cards. She buys \(b) more, then gives \(c) away. How many cards now?",
                answerType: .numberEntry,
                correctAnswer: "\(a + b - c)",
                hint: "Add first, then subtract.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "There are \(a) apples in a basket. \(b) more are added. The basket holds \(a + b + c) apples. How many more can fit?",
            answerType: .numberEntry,
            correctAnswer: "\(c)",
            hint: "Find total after adding, then how many more to fill.",
            teksId: topic.teks
        )
    }

    private static func unitFractions(topic: Topic, difficulty: Difficulty) -> Problem {
        let denom = [2, 3, 4, 6, 8].randomElement()!
        return Problem(
            questionText: "What is the unit fraction for one part of a shape split into \(denom) equal parts?",
            answerType: .multipleChoice,
            correctAnswer: "1/\(denom)",
            choices: multipleChoiceOptions(correct: "1/\(denom)", distractors: ["\(denom)/1", "1/\(denom * 2)", "2/\(denom)"]),
            hint: "Unit fraction means 1 over the number of parts.",
            teksId: topic.teks
        )
    }

    private static func equivalentFractions(topic: Topic, difficulty: Difficulty) -> Problem {
        let pairs: [(String, String)] = [("1/2", "2/4"), ("1/3", "2/6"), ("1/4", "2/8"), ("2/3", "4/6")]
        let pair = pairs.randomElement()!
        if Bool.random() {
            return Problem(
                questionText: "Which fraction equals \(pair.0)?",
                answerType: .tapSelection,
                correctAnswer: pair.1,
                hint: "Multiply top and bottom by the same number.",
                teksId: topic.teks,
                tapOptions: [pair.1, "1/5", "3/4", pair.0 == "1/2" ? "1/3" : "1/2"]
            )
        }
        return Problem(
            questionText: "Are \(pair.0) and \(pair.1) equivalent?",
            answerType: .tapSelection,
            correctAnswer: "yes",
            teksId: topic.teks,
            tapOptions: ["yes", "no"]
        )
    }

    private static func shapesQuadrilaterals(topic: Topic, difficulty: Difficulty) -> Problem {
        let quads: [(String, String)] = [
            ("square", "4 equal sides and 4 right angles"),
            ("rectangle", "4 right angles, opposite sides equal"),
            ("rhombus", "4 equal sides"),
            ("trapezoid", "exactly one pair of parallel sides"),
        ]
        let q = quads.randomElement()!
        return Problem(
            questionText: "Which shape matches: \(q.1)?",
            answerType: .tapSelection,
            correctAnswer: q.0,
            hint: "A quadrilateral has 4 sides.",
            teksId: topic.teks,
            tapOptions: quads.map(\.0)
        )
    }

    private static func evenOdd3(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 10..<100, medium: 100..<500, hard: 500...999))
        if Bool.random() {
            let isEven = n % 2 == 0
            return Problem(
                questionText: "Is \(n) even or odd?",
                answerType: .tapSelection,
                correctAnswer: isEven ? "even" : "odd",
                hint: "Even numbers end in 0, 2, 4, 6, or 8.",
                teksId: topic.teks,
                tapOptions: ["even", "odd"]
            )
        }
        let a = randomInt(in: range(for: difficulty, easy: 2..<10, medium: 4..<15, hard: 6...20))
        let product = a * (Bool.random() ? 2 : 3)
        return Problem(
            questionText: "\(product) is divisible by 2. Is \(product) even or odd?",
            answerType: .tapSelection,
            correctAnswer: product % 2 == 0 ? "even" : "odd",
            hint: "Numbers divisible by 2 with no remainder are even.",
            teksId: topic.teks,
            tapOptions: ["even", "odd"]
        )
    }

    private static func numberPatterns3(topic: Topic, difficulty: Difficulty) -> Problem {
        let start = randomInt(in: range(for: difficulty, easy: 2..<10, medium: 5..<20, hard: 10...40))
        let rule = difficulty == .easy ? 2 : (difficulty == .medium ? 5 : 10)
        let seq = (0..<4).map { start + $0 * rule }
        let blank = Int.random(in: 1...2)
        if Bool.random() {
            var display = seq.map(String.init)
            display[blank] = "?"
            return Problem(
                questionText: "Find the rule: \(display.joined(separator: ", ")). What number replaces ??",
                answerType: .numberEntry,
                correctAnswer: "\(seq[blank])",
                hint: "How much does each number increase?",
                teksId: topic.teks
            )
        }
        let input = seq[2]
        let output = seq[2] * 2
        return Problem(
            questionText: "In a table, when input is \(input), output is \(output). The rule is multiply by ___",
            answerType: .numberEntry,
            correctAnswer: "2",
            hint: "What do you multiply the input by to get the output?",
            teksId: topic.teks
        )
    }

    private static func shapes3D3(topic: Topic, difficulty: Difficulty) -> Problem {
        let solids: [(String, String)] = [
            ("cube", "6 square faces"),
            ("sphere", "round like a ball"),
            ("cylinder", "two circular bases"),
            ("cone", "one circular base and a point"),
            ("rectangular prism", "6 rectangular faces"),
        ]
        let s = solids.randomElement()!
        return Problem(
            questionText: "Which 3D solid matches: \(s.1)?",
            answerType: .tapSelection,
            correctAnswer: s.0,
            hint: "Count faces, edges, and whether it rolls.",
            teksId: topic.teks,
            tapOptions: solids.map(\.0)
        )
    }

    private static func geoMeasureWordProblems3(topic: Topic, difficulty: Difficulty) -> Problem {
        let w = randomInt(in: range(for: difficulty, easy: 3..<8, medium: 5..<12, hard: 8...15))
        let h = randomInt(in: range(for: difficulty, easy: 3..<8, medium: 5..<12, hard: 8...15))
        if Bool.random() {
            return Problem(
                questionText: "A garden is \(w) m long and \(h) m wide. What is the perimeter?",
                visual: .rectangle(width: w, height: h),
                answerType: .numberEntry,
                correctAnswer: "\(2 * (w + h))",
                hint: "Add all four sides.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "A poster is \(w) cm by \(h) cm. What is the area in square cm?",
            visual: .rectangle(width: w, height: h),
            answerType: .numberEntry,
            correctAnswer: "\(w * h)",
            hint: "Area = length × width.",
            teksId: topic.teks
        )
    }

    private static func measurementUnits3(topic: Topic, difficulty: Difficulty) -> Problem {
        let variant = Int.random(in: 0...3)
        switch variant {
        case 0:
            let cups = randomInt(in: 2...8)
            return Problem(
                questionText: "A bottle holds \(cups) cups of water. Which unit measures liquid volume?",
                answerType: .tapSelection,
                correctAnswer: "cups",
                hint: "Liquid volume uses cups, liters, or gallons.",
                teksId: topic.teks,
                tapOptions: ["cups", "miles", "pounds", "hours"]
            )
        case 1:
            let grams = randomInt(in: range(for: difficulty, easy: 100..<500, medium: 500..<2000, hard: 2000...5000))
            return Problem(
                questionText: "A book has a mass of \(grams) grams. Which system uses grams?",
                answerType: .tapSelection,
                correctAnswer: "metric",
                teksId: topic.teks,
                tapOptions: ["metric", "customary only", "time", "money"]
            )
        case 2:
            let feet = Int.random(in: 2...6)
            return Problem(
                questionText: "How many inches are in \(feet) feet?",
                answerType: .numberEntry,
                correctAnswer: "\(feet * 12)",
                hint: "1 foot = 12 inches.",
                teksId: topic.teks
            )
        default:
            let meters = Int.random(in: 1...3)
            return Problem(
                questionText: "How many centimeters are in \(meters) meter\(meters == 1 ? "" : "s")?",
                answerType: .numberEntry,
                correctAnswer: "\(meters * 100)",
                hint: "1 meter = 100 centimeters.",
                teksId: topic.teks
            )
        }
    }

    private static func financialLiteracy3(topic: Topic, difficulty: Difficulty) -> Problem {
        let scenarios: [(String, String, [String], Bool)] = [
            ("Inaya earns $10 doing chores. She puts $4 in savings. How much can she still spend?", "6", [], true),
            ("Giving money to a charity is called ___", "donating", ["borrowing", "taxing", "weighing"], false),
            ("Why is saving money a smart choice?", "for future needs", ["to lose it", "because banks disappear", "to avoid math"], false),
            ("Credit means borrowing now and paying ___", "later", ["never", "with toys", "with homework"], false),
            ("Which is income?", "money earned from a job", ["a broken toy", "rain", "a shadow"], false),
        ]
        let pick = scenarios.randomElement()!
        if pick.3 {
            return Problem(
                questionText: pick.0,
                answerType: .numberEntry,
                correctAnswer: pick.1,
                hint: "Think about money earned, spent, and saved.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: pick.0,
            answerType: .multipleChoice,
            correctAnswer: pick.1,
            choices: multipleChoiceOptions(correct: pick.1, distractors: pick.2),
            hint: "Think about earning, saving, spending, and giving.",
            teksId: topic.teks
        )
    }

    // MARK: - Math POT 2 catch-up (July 2026)

    private static func potFactFamilies2(topic: Topic, difficulty: Difficulty) -> Problem {
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
                hint: "Addition and subtraction are opposites in a fact family.",
                teksId: topic.teks
            )
        case 1:
            return Problem(
                questionText: "Which goes with \(a) + \(b) = \(sum)?",
                answerType: .multipleChoice,
                correctAnswer: "\(sum) − \(b) = \(a)",
                choices: multipleChoiceOptions(correct: "\(sum) − \(b) = \(a)", distractors: [
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
                hint: "What plus \(a) makes \(sum)?",
                teksId: topic.teks
            )
        }
    }

    private static func potBoxDiagrams2(topic: Topic, difficulty: Difficulty) -> Problem {
        let a = Int.random(in: range(for: difficulty, easy: 5..<20, medium: 20..<60, hard: 60...120))
        let b = Int.random(in: range(for: difficulty, easy: 3..<15, medium: 10..<40, hard: 30...80))
        return Problem(
            questionText: "Inaya has \(a) stickers. She gets \(b) more. Draw a box diagram: one box for \(a), one for \(b). How many in all?",
            answerType: .numberEntry,
            correctAnswer: "\(a + b)",
            hint: "Add the two parts shown in the boxes.",
            teksId: topic.teks
        )
    }

    private static func potRounding2(topic: Topic, difficulty: Difficulty) -> Problem {
        let n = randomInt(in: range(for: difficulty, easy: 15..<100, medium: 100..<1000, hard: 500...1200))
        let roundToTen = ((n + 5) / 10) * 10
        if difficulty == .easy || Bool.random() {
            return Problem(
                questionText: "Round \(n) to the nearest ten.",
                answerType: .numberEntry,
                correctAnswer: "\(roundToTen)",
                hint: "Look at the ones digit: 5 or more rounds up.",
                teksId: topic.teks
            )
        }
        let roundToHundred = ((n + 50) / 100) * 100
        return Problem(
            questionText: "Round \(n) to the nearest hundred.",
            answerType: .numberEntry,
            correctAnswer: "\(roundToHundred)",
            hint: "Look at the tens digit to decide up or down.",
            teksId: topic.teks
        )
    }

    private static func potTimeWordProblems2(topic: Topic, difficulty: Difficulty) -> Problem {
        let startHour = Int.random(in: 1...11)
        let addHours = Int.random(in: 1...(difficulty == .easy ? 2 : 4))
        let endHour = startHour + addHours
        return Problem(
            questionText: "Inaya starts reading at \(startHour):00. She reads for \(addHours) hours. What time does she finish? (Use :00 format, e.g. 3:00)",
            answerType: .numberEntry,
            correctAnswer: "\(endHour):00",
            hint: "Add the hours to the start time.",
            teksId: topic.teks
        )
    }

    private static func potAddThreeNumbers2(topic: Topic, difficulty: Difficulty) -> Problem {
        let a = Int.random(in: range(for: difficulty, easy: 10..<100, medium: 100..<400, hard: 200...600))
        let b = Int.random(in: range(for: difficulty, easy: 10..<100, medium: 50..<300, hard: 100...400))
        let c = Int.random(in: range(for: difficulty, easy: 5..<50, medium: 20..<200, hard: 50...300))
        return Problem(
            questionText: "What is \(a) + \(b) + \(c)?",
            answerType: .numberEntry,
            correctAnswer: "\(a + b + c)",
            hint: "Add two numbers first, then add the third.",
            teksId: topic.teks
        )
    }

    private static func potSolidGeometry2(topic: Topic, difficulty: Difficulty) -> Problem {
        let shapes: [(String, Int, Int, Int)] = [
            ("cube", 6, 12, 8),
            ("rectangular prism", 6, 12, 8),
            ("square pyramid", 5, 8, 5),
            ("triangular prism", 5, 9, 6),
        ]
        let s = shapes.randomElement()!
        let ask = ["faces", "edges", "vertices"].randomElement()!
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
            hint: "Count flat surfaces (faces), line segments (edges), or corner points (vertices).",
            teksId: topic.teks
        )
    }

    private static func potCoinWordProblems2(topic: Topic, difficulty: Difficulty) -> Problem {
        let price = priceCents(difficulty: difficulty)
        var price2 = priceCents(difficulty: difficulty)
        if difficulty == .easy { price2 = 0 }
        let total = price + price2
        let paid = ((total + 99) / 100) * 100
        if price2 == 0 {
            return Problem(
                questionText: "A toy costs \(formatCents(price)). Inaya pays \(formatCents(paid)). How much change?",
                answerType: .numberEntry,
                correctAnswer: formatCents(paid - price),
                hint: "Subtract the price from what she paid.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "Inaya buys fruit for \(formatCents(price)) and juice for \(formatCents(price2)). How much does she spend?",
            answerType: .numberEntry,
            correctAnswer: formatCents(total),
            teksId: topic.teks
        )
    }

    private static func potFractionOfSet2(topic: Topic, difficulty: Difficulty) -> Problem {
        let denom = [2, 3, 4].randomElement()!
        let numer = 1
        let total = denom * Int.random(in: 2...(difficulty == .easy ? 4 : 8))
        let part = total * numer / denom
        return Problem(
            questionText: "There are \(total) apples. What is \(numer)/\(denom) of the apples?",
            answerType: .numberEntry,
            correctAnswer: "\(part)",
            hint: "Divide the total into \(denom) equal groups. Take \(numer) group.",
            teksId: topic.teks
        )
    }

    private static func potLineGraphs2(topic: Topic, difficulty: Difficulty) -> Problem {
        let days = ["Mon", "Tue", "Wed", "Thu"]
        let values = days.map { _ in Int.random(in: 2...10) }
        let data = zip(days, values).map { ($0.0, $0.1) }
        let i = Int.random(in: 0..<days.count)
        let j = (i + 1) % days.count
        if Bool.random() {
            return Problem(
                questionText: "Line graph: \(data.map { "\($0.0) \($0.1)" }.joined(separator: ", ")). How many on \(days[i])?",
                answerType: .numberEntry,
                correctAnswer: "\(values[i])",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "Line graph: \(data.map { "\($0.0) \($0.1)" }.joined(separator: ", ")). How many more on \(days[i]) than \(days[j])?",
            answerType: .numberEntry,
            correctAnswer: "\(abs(values[i] - values[j]))",
            hint: "Subtract the smaller value from the larger.",
            teksId: topic.teks
        )
    }

    private static func potVennDiagrams2(topic: Topic, difficulty: Difficulty) -> Problem {
        let onlyA = Int.random(in: 2...8)
        let onlyB = Int.random(in: 2...8)
        let both = Int.random(in: 1...5)
        if Bool.random() {
            return Problem(
                questionText: "Venn diagram: \(onlyA) only in Art, \(onlyB) only in Music, \(both) in both. How many in Art (including both)?",
                answerType: .numberEntry,
                correctAnswer: "\(onlyA + both)",
                hint: "Add the Art-only and the overlap.",
                teksId: topic.teks
            )
        }
        return Problem(
            questionText: "Venn diagram: \(onlyA) only cats, \(onlyB) only dogs, \(both) both. How many animals total?",
            answerType: .numberEntry,
            correctAnswer: "\(onlyA + onlyB + both)",
            hint: "Add all three regions.",
            teksId: topic.teks
        )
    }

    private static func potLogicReasoning2(topic: Topic, difficulty: Difficulty) -> Problem {
        let names = ["Inaya", "Maya", "Sam", "Zoe"].shuffled().prefix(3)
        let n = Array(names)
        let heights = ["tallest", "shortest", "middle"].shuffled()
        if difficulty == .easy {
            return Problem(
                questionText: "\(n[0]) is taller than \(n[1]). \(n[1]) is taller than \(n[2]). Who is tallest?",
                answerType: .tapSelection,
                correctAnswer: n[0],
                teksId: topic.teks,
                tapOptions: n
            )
        }
        return Problem(
            questionText: "Logic table: Red > Blue, Blue > Green. Which color is \(heights[0])?",
            answerType: .tapSelection,
            correctAnswer: heights[0] == "tallest" ? "Red" : (heights[0] == "shortest" ? "Green" : "Blue"),
            teksId: topic.teks,
            tapOptions: ["Red", "Blue", "Green"]
        )
    }

    private static func potMultiplyMultidigit2(topic: Topic, difficulty: Difficulty) -> Problem {
        let multiplier = Int.random(in: 2...(difficulty == .easy ? 5 : 9))
        let n = randomInt(in: range(for: difficulty, easy: 10..<30, medium: 20..<100, hard: 100...400))
        return Problem(
            questionText: "What is \(n) × \(multiplier)?",
            answerType: .numberEntry,
            correctAnswer: "\(n * multiplier)",
            hint: "Multiply ones first, then regroup if needed.",
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

struct MathProblemGenerator: ProblemGenerating {
    let topic: Topic

    var subject: Subject { .math }

    func generate(difficulty: Difficulty) -> Problem {
        ProblemGenerator.generate(topic: topic, difficulty: difficulty)
    }
}
