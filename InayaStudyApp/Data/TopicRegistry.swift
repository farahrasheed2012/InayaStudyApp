import Foundation

enum TopicRegistry {
    static let all: [Topic] = mathSecondGrade + mathThirdGrade + scienceSecondGrade

    static let mathSecondGrade: [Topic] = [
        Topic(id: "place-value-1200", subject: .math, grade: .second, name: "Place Value to 1,200", teks: "2.2A", icon: "number.square", color: "5B8DEF"),
        Topic(id: "compare-order", subject: .math, grade: .second, name: "Comparing & Ordering Numbers", teks: "2.2D", icon: "arrow.left.arrow.right", color: "9B59B6"),
        Topic(id: "add-sub-1000", subject: .math, grade: .second, name: "Addition & Subtraction to 1,000", teks: "2.4B", icon: "plus.forwardslash.minus", color: "2ECC71"),
        Topic(id: "skip-counting", subject: .math, grade: .second, name: "Skip Counting (2s, 5s, 10s, 100s)", teks: "2.2C", icon: "figure.walk", color: "E67E22"),
        Topic(id: "even-odd", subject: .math, grade: .second, name: "Even & Odd Numbers", teks: "2.2E", icon: "checkerboard.rectangle", color: "1ABC9C"),
        Topic(id: "fractions-basic", subject: .math, grade: .second, name: "Basic Fractions (½, ¼, ⅛)", teks: "2.3A", icon: "circle.lefthalf.filled", color: "E74C3C"),
        Topic(id: "time-minutes", subject: .math, grade: .second, name: "Telling Time to the Minute", teks: "2.9G", icon: "clock", color: "3498DB"),
        Topic(id: "money-coins", subject: .math, grade: .second, name: "Counting Coins & Dollars", teks: "2.5A", icon: "dollarsign.circle", color: "F1C40F"),
        Topic(id: "measurement-length", subject: .math, grade: .second, name: "Measuring Length", teks: "2.9D", icon: "ruler", color: "8E44AD"),
    ]

    static let mathThirdGrade: [Topic] = [
        Topic(id: "multiplication", subject: .math, grade: .third, name: "Multiplication Facts 0–12", teks: "3.4E", icon: "multiply", color: "2980B9"),
        Topic(id: "division", subject: .math, grade: .third, name: "Division Facts 0–12", teks: "3.4F", icon: "divide", color: "16A085"),
        Topic(id: "arrays-area-model", subject: .math, grade: .third, name: "Arrays & Area Models", teks: "3.4C", icon: "square.grid.3x3", color: "D35400"),
        Topic(id: "fractions-number-line", subject: .math, grade: .third, name: "Fractions on a Number Line", teks: "3.3A", icon: "chart.bar", color: "C0392B"),
        Topic(id: "compare-fractions", subject: .math, grade: .third, name: "Comparing Fractions", teks: "3.3H", icon: "lessthan.circle", color: "8E44AD"),
        Topic(id: "elapsed-time", subject: .math, grade: .third, name: "Elapsed Time", teks: "3.7C", icon: "clock.arrow.circlepath", color: "2C3E50"),
        Topic(id: "perimeter-area", subject: .math, grade: .third, name: "Perimeter & Area", teks: "3.6C", icon: "square.dashed", color: "27AE60"),
        Topic(id: "data-graphs", subject: .math, grade: .third, name: "Data & Graphs", teks: "3.8A", icon: "chart.bar.xaxis", color: "E91E63"),
        Topic(id: "money-word-problems", subject: .math, grade: .third, name: "Money Word Problems", teks: "3.4K", icon: "dollarsign", color: "F39C12"),
        Topic(id: "staar-mixed", subject: .math, grade: .third, name: "STAAR Mixed Review", teks: "3.all", icon: "star", color: "9B59B6"),
    ]

    static let scienceSecondGrade: [Topic] = [
        Topic(id: "sci-matter-properties", subject: .science, grade: .second, name: "Matter & Its Properties", teks: "2.5A", icon: "atom", color: "E8A838"),
        Topic(id: "sci-matter-changes", subject: .science, grade: .second, name: "Changes to Matter", teks: "2.5B", icon: "flame", color: "E8622A"),
        Topic(id: "sci-force-motion", subject: .science, grade: .second, name: "Force & Motion", teks: "2.6A", icon: "arrow.right.circle", color: "5B8FE8"),
        Topic(id: "sci-energy-forms", subject: .science, grade: .second, name: "Forms of Energy", teks: "2.6B", icon: "bolt.circle", color: "F5C842"),
        Topic(id: "sci-sound-light", subject: .science, grade: .second, name: "Sound & Light", teks: "2.6C", icon: "waveform", color: "9B59E8"),
        Topic(id: "sci-earth-materials", subject: .science, grade: .second, name: "Earth Materials", teks: "2.7A", icon: "mountain.2", color: "7DAE5A"),
        Topic(id: "sci-sky-patterns", subject: .science, grade: .second, name: "Patterns in the Sky", teks: "2.7B", icon: "sun.max", color: "F07A3A"),
        Topic(id: "sci-plant-structures", subject: .science, grade: .second, name: "Plant Structures", teks: "2.8A", icon: "leaf", color: "3AAF6A"),
        Topic(id: "sci-animal-needs", subject: .science, grade: .second, name: "Animal Needs & Adaptations", teks: "2.8B", icon: "pawprint", color: "E85C8A"),
        Topic(id: "sci-life-cycles", subject: .science, grade: .second, name: "Life Cycles", teks: "2.8C", icon: "arrow.triangle.2.circlepath", color: "45C4B0"),
        Topic(id: "sci-habitats", subject: .science, grade: .second, name: "Habitats & Environments", teks: "2.8D", icon: "tree", color: "5A9E6F"),
        Topic(id: "sci-science-tools", subject: .science, grade: .second, name: "Science Tools & Safety", teks: "2.2A", icon: "wrench.and.screwdriver", color: "8E8E93"),
    ]

    /// Math-only aliases for existing tests and STAAR mixed pool.
    static let secondGrade: [Topic] = mathSecondGrade
    static let thirdGrade: [Topic] = mathThirdGrade

    static func topic(id: String) -> Topic? {
        all.first { $0.id == id }
    }

    static func topics(for grade: GradeLevel, subject: Subject) -> [Topic] {
        switch (subject, grade) {
        case (.math, .second): return mathSecondGrade
        case (.math, .third): return mathThirdGrade
        case (.science, .second): return scienceSecondGrade
        case (.science, .third): return []
        }
    }

    static func topics(for grade: GradeLevel) -> [Topic] {
        topics(for: grade, subject: .math)
    }

    static func grades(for subject: Subject) -> [GradeLevel] {
        switch subject {
        case .math: return GradeLevel.allCases
        case .science: return [.second]
        }
    }

    static var thirdGradePracticeTopics: [Topic] {
        mathThirdGrade.filter { $0.id != "staar-mixed" }
    }
}
