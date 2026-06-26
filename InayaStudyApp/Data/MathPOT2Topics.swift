import Foundation

/// Math POT Level 2 curriculum — Texas TEKS 2nd–3rd grade (T032–T059).
enum MathPOT2Topics {
    private static func pot2(
        code: String,
        name: String,
        teks: String,
        icon: String,
        color: String,
        competition: Bool = false
    ) -> Topic {
        Topic(
            id: "pot2-\(code.lowercased())",
            subject: .math,
            grade: .second,
            name: name,
            teks: teks,
            icon: icon,
            color: color,
            potCode: code,
            gradeRange: "2–3",
            isCompetitionOnly: competition
        )
    }

    static let all: [Topic] = [
        pot2(code: "T032", name: "Read a Clock", teks: "2.9G", icon: "clock", color: "3498DB"),
        pot2(code: "T033", name: "Box Diagrams", teks: "2.4D", icon: "rectangle.split.3x1", color: "00B894"),
        pot2(code: "T034", name: "Add Large Numbers", teks: "2.4B", icon: "plus.circle.fill", color: "2ECC71"),
        pot2(code: "T035", name: "Subtract Large Numbers", teks: "2.4B", icon: "minus.circle.fill", color: "27AE60"),
        pot2(code: "T036", name: "Fact Families", teks: "2.4B", icon: "arrow.triangle.2.circlepath", color: "55EFC4"),
        pot2(code: "T037", name: "Read & Write Large Numbers", teks: "2.2A", icon: "textformat.123", color: "5B8DEF"),
        pot2(code: "T038", name: "Compare Large Numbers", teks: "2.2D", icon: "arrow.left.arrow.right", color: "9B59B6"),
        pot2(code: "T039", name: "Build Numbers from Digits", teks: "2.2B", icon: "number.square", color: "6C5CE7"),
        pot2(code: "T040", name: "Place Value", teks: "2.2A", icon: "square.stack.3d.up", color: "74B9FF"),
        pot2(code: "T041", name: "Elapsed Time", teks: "2.9G", icon: "clock.arrow.circlepath", color: "2980B9"),
        pot2(code: "T042", name: "Chickens & Rabbits", teks: "2.4D", icon: "hare.fill", color: "E67E22", competition: true),
        pot2(code: "T043", name: "Add Three or More Numbers", teks: "2.4B", icon: "plus.forwardslash.minus", color: "1ABC9C"),
        pot2(code: "T044", name: "Faces, Edges & Vertices", teks: "2.7A", icon: "cube.transparent", color: "9B59B6"),
        pot2(code: "T045", name: "Bar Graphs", teks: "2.8A", icon: "chart.bar", color: "FDCB6E"),
        pot2(code: "T046", name: "Coins & Change", teks: "2.5A", icon: "dollarsign.circle", color: "F1C40F"),
        pot2(code: "T047", name: "Fractions & Mixed Numbers", teks: "2.3A", icon: "circle.lefthalf.filled", color: "E74C3C"),
        pot2(code: "T048", name: "Line Graphs", teks: "2.8A", icon: "chart.xyaxis.line", color: "F39C12"),
        pot2(code: "T049", name: "Rounding Numbers", teks: "2.2D", icon: "arrow.up.and.down.circle", color: "00CEC9"),
        pot2(code: "T050", name: "Two-Circle Venn Diagram", teks: "2.8A", icon: "circle.circle", color: "6C5CE7"),
        pot2(code: "T051", name: "Count Cubes in 3D Stacks", teks: "2.7A", icon: "cube.fill", color: "8E44AD", competition: true),
        pot2(code: "T052", name: "Three-Circle Venn Diagram", teks: "2.8A", icon: "circles.hexagongrid", color: "A29BFE", competition: true),
        pot2(code: "T053", name: "Frog Out of the Hole", teks: "2.4D", icon: "leaf.fill", color: "27AE60", competition: true),
        pot2(code: "T054", name: "Missing Numbers in Equations", teks: "2.4B", icon: "questionmark.square", color: "E17055", competition: true),
        pot2(code: "T055", name: "Comparison Chains", teks: "2.4D", icon: "arrow.up.arrow.down", color: "D35400"),
        pot2(code: "T056", name: "Logic Deduction Tables", teks: "2.4D", icon: "tablecells", color: "636E72"),
        pot2(code: "T057", name: "Introduction to Multiplication", teks: "2.6A", icon: "rectangle.grid.2x2", color: "2980B9"),
        pot2(code: "T058", name: "Venn Diagram Word Problems", teks: "2.8A", icon: "text.bubble", color: "9B59B6"),
        pot2(code: "T059", name: "Multiply by One Digit", teks: "2.6A", icon: "multiply.circle.fill", color: "A29BFE"),
    ]

    static func topic(forCode code: String) -> Topic? {
        all.first { $0.potCode == code }
    }
}
