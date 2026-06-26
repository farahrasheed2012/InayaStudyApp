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
    /// Math POT 2 code (e.g. "T032") when this topic is part of the POT2 curriculum.
    let potCode: String?
    /// Display grade span for POT2 topics (e.g. "2–3").
    let gradeRange: String?
    /// Competition-only POT2 challenge topics show a star badge in lists.
    let isCompetitionOnly: Bool

    init(
        id: String,
        subject: Subject,
        grade: GradeLevel,
        name: String,
        teks: String,
        icon: String,
        color: String,
        potCode: String? = nil,
        gradeRange: String? = nil,
        isCompetitionOnly: Bool = false
    ) {
        self.id = id
        self.subject = subject
        self.grade = grade
        self.name = name
        self.teks = teks
        self.icon = icon
        self.color = color
        self.potCode = potCode
        self.gradeRange = gradeRange
        self.isCompetitionOnly = isCompetitionOnly
    }

    var difficultyLevels: [Difficulty] { Difficulty.allCases }

    var isPOT2Topic: Bool { potCode != nil }

    enum CodingKeys: String, CodingKey {
        case id, subject, grade, name, teks, icon, color, potCode, gradeRange, isCompetitionOnly
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        subject = try container.decode(Subject.self, forKey: .subject)
        grade = try container.decode(GradeLevel.self, forKey: .grade)
        name = try container.decode(String.self, forKey: .name)
        teks = try container.decode(String.self, forKey: .teks)
        icon = try container.decode(String.self, forKey: .icon)
        color = try container.decode(String.self, forKey: .color)
        potCode = try container.decodeIfPresent(String.self, forKey: .potCode)
        gradeRange = try container.decodeIfPresent(String.self, forKey: .gradeRange)
        isCompetitionOnly = try container.decodeIfPresent(Bool.self, forKey: .isCompetitionOnly) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(subject, forKey: .subject)
        try container.encode(grade, forKey: .grade)
        try container.encode(name, forKey: .name)
        try container.encode(teks, forKey: .teks)
        try container.encode(icon, forKey: .icon)
        try container.encode(color, forKey: .color)
        try container.encodeIfPresent(potCode, forKey: .potCode)
        try container.encodeIfPresent(gradeRange, forKey: .gradeRange)
        try container.encode(isCompetitionOnly, forKey: .isCompetitionOnly)
    }
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
    case lineGraph(labels: [String], values: [Int])
    case vennDiagram2(onlyA: Int, onlyB: Int, both: Int, labelA: String, labelB: String)
    case vennDiagram3(onlyA: Int, onlyB: Int, onlyC: Int, ab: Int, ac: Int, bc: Int, abc: Int, labelA: String, labelB: String, labelC: String)
    case cubeStack(rows: Int, cols: Int, hidden: Int)
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
