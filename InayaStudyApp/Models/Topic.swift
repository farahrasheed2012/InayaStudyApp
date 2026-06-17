import Foundation

enum Subject: String, CaseIterable, Codable, Identifiable {
    case math = "Math"
    case science = "Science"

    var id: String { rawValue }
}

enum GradeLevel: String, CaseIterable, Codable, Identifiable {
    case second = "2nd Grade"
    case third = "3rd Grade"

    var id: String { rawValue }
}

struct Topic: Identifiable, Codable, Hashable {
    let id: String
    let subject: Subject
    let grade: GradeLevel
    let name: String
    let teks: String
    let icon: String
    let color: String
}

enum Difficulty: String, CaseIterable, Codable, Identifiable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var friendlyLabel: String {
        switch self {
        case .easy: return "Just starting"
        case .medium: return "Getting good"
        case .hard: return "Challenge me!"
        }
    }
}

enum AnswerType: Codable, Equatable {
    case multipleChoice
    case numberEntry
    case tapSelection
}

enum CoinType: String, Codable, CaseIterable {
    case penny, nickel, dime, quarter, dollar

    var cents: Int {
        switch self {
        case .penny: return 1
        case .nickel: return 5
        case .dime: return 10
        case .quarter: return 25
        case .dollar: return 100
        }
    }
}

enum ProblemVisual {
    case clockFace(hour: Int, minute: Int)
    case coins([CoinType])
    case numberLine(min: Int, max: Int, marked: [Int])
    case array(rows: Int, cols: Int)
    case fractionCircle(numerator: Int, denominator: Int)
    case barGraph(data: [(label: String, value: Int)])
    case rectangle(width: Int, height: Int)
    case matterState(String)
    case foodChain(producer: String, herbivore: String, carnivore: String)
    case lifeCycle(kind: String, stages: [String])
    case scienceTool(name: String, symbol: String)
}

struct Problem: Identifiable {
    let id: UUID
    let questionText: String
    let visual: ProblemVisual?
    let answerType: AnswerType
    let correctAnswer: String
    let choices: [String]?
    let hint: String?
    let teksId: String
    let tapOptions: [String]?
    let funFact: String?

    init(
        id: UUID = UUID(),
        questionText: String,
        visual: ProblemVisual? = nil,
        answerType: AnswerType,
        correctAnswer: String,
        choices: [String]? = nil,
        hint: String? = nil,
        teksId: String,
        tapOptions: [String]? = nil,
        funFact: String? = nil
    ) {
        self.id = id
        self.questionText = questionText
        self.visual = visual
        self.answerType = answerType
        self.correctAnswer = correctAnswer
        self.choices = choices
        self.hint = hint
        self.teksId = teksId
        self.tapOptions = tapOptions
        self.funFact = funFact
    }
}
