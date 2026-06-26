import Foundation

enum TopicRegistry {
    static let all: [Topic] = mathSecondGrade + mathPOTCatchUpTopics + mathThirdGrade + scienceSecondGrade + scienceThirdGrade

    /// All 28 Math POT Level 2 topics (T032–T059).
    static var mathPOT2Topics: [Topic] { MathPOT2Topics.all }

    /// Math POT 2 catch-up path — dedicated POT2 topics plus mixed review.
    static let mathPOTCatchUpTopics: [Topic] = MathPOT2Topics.all + [
        Topic(id: "pot-mixed-catchup-2", subject: .math, grade: .second, name: "Math POT Mixed Review", teks: "2.all", icon: "star.circle.fill", color: "E17055"),
    ]

    static var potCatchUpPracticeTopics: [Topic] {
        mathPOT2Topics
    }

    static let mathSecondGrade: [Topic] = [
        Topic(id: "place-value-1200", subject: .math, grade: .second, name: "Place Value to 1,200", teks: "2.2A", icon: "number.square", color: "5B8DEF"),
        Topic(id: "compose-decompose", subject: .math, grade: .second, name: "Compose & Decompose Numbers", teks: "2.2B", icon: "square.stack.3d.up", color: "6C5CE7"),
        Topic(id: "compare-order", subject: .math, grade: .second, name: "Comparing & Ordering Numbers", teks: "2.2D", icon: "arrow.left.arrow.right", color: "9B59B6"),
        Topic(id: "number-word-form", subject: .math, grade: .second, name: "Number Word Form", teks: "2.2A", icon: "textformat.abc", color: "FFEAA7"),
        Topic(id: "more-or-less-100", subject: .math, grade: .second, name: "10 & 100 More or Less", teks: "2.2B", icon: "arrow.up.and.down", color: "74B9FF"),
        Topic(id: "number-line-1200", subject: .math, grade: .second, name: "Number Line to 1,200", teks: "2.2D", icon: "line.3.horizontal", color: "A29BFE"),
        Topic(id: "facts-to-100", subject: .math, grade: .second, name: "Math Facts to 100", teks: "2.4B", icon: "plusminus", color: "55EFC4"),
        Topic(id: "add-sub-1000", subject: .math, grade: .second, name: "Addition & Subtraction to 1,000", teks: "2.4B", icon: "plus.forwardslash.minus", color: "2ECC71"),
        Topic(id: "word-problems-addsub-2", subject: .math, grade: .second, name: "Add & Sub Word Problems", teks: "2.4D", icon: "text.bubble", color: "00B894"),
        Topic(id: "skip-counting", subject: .math, grade: .second, name: "Skip Counting (2s, 5s, 10s, 100s)", teks: "2.2C", icon: "figure.walk", color: "E67E22"),
        Topic(id: "even-odd", subject: .math, grade: .second, name: "Even & Odd Numbers", teks: "2.2E", icon: "checkerboard.rectangle", color: "1ABC9C"),
        Topic(id: "fractions-basic", subject: .math, grade: .second, name: "Basic Fractions (½, ¼, ⅛)", teks: "2.3A", icon: "circle.lefthalf.filled", color: "E74C3C"),
        Topic(id: "fraction-models", subject: .math, grade: .second, name: "Fraction Models with Shapes", teks: "2.3B", icon: "square.split.2x2", color: "FD79A8"),
        Topic(id: "arrays-groups-2", subject: .math, grade: .second, name: "Arrays & Equal Groups", teks: "2.6A", icon: "rectangle.grid.2x2", color: "A29BFE"),
        Topic(id: "equal-sharing-2", subject: .math, grade: .second, name: "Equal Sharing & Fair Shares", teks: "2.6A", icon: "person.2", color: "FF7675"),
        Topic(id: "area-square-units-2", subject: .math, grade: .second, name: "Area with Square Units", teks: "2.7A", icon: "square.grid.3x3", color: "00B894"),
        Topic(id: "shapes-2d-3d", subject: .math, grade: .second, name: "2D & 3D Shapes", teks: "2.7A", icon: "cube", color: "74B9FF"),
        Topic(id: "graphs-data-2", subject: .math, grade: .second, name: "Pictographs & Bar Graphs", teks: "2.8A", icon: "chart.bar", color: "FDCB6E"),
        Topic(id: "time-minutes", subject: .math, grade: .second, name: "Telling Time to the Minute", teks: "2.9G", icon: "clock", color: "3498DB"),
        Topic(id: "money-coins", subject: .math, grade: .second, name: "Counting Coins & Dollars", teks: "2.5A", icon: "dollarsign.circle", color: "F1C40F"),
        Topic(id: "financial-literacy-2", subject: .math, grade: .second, name: "Saving, Spending & Money Choices", teks: "2.11A", icon: "banknote", color: "FDCB6E"),
        Topic(id: "measurement-length", subject: .math, grade: .second, name: "Measuring Length", teks: "2.9D", icon: "ruler", color: "8E44AD"),
        Topic(id: "measurement-metric-2", subject: .math, grade: .second, name: "Centimeters & Meters", teks: "2.9D", icon: "ruler.fill", color: "81ECEC"),
        Topic(id: "measurement-wct", subject: .math, grade: .second, name: "Weight, Capacity & Temperature", teks: "2.9A", icon: "scalemass", color: "636E72"),
        Topic(id: "staar-mixed-2", subject: .math, grade: .second, name: "2nd Grade STAAR Mixed Review", teks: "2.all", icon: "star.circle", color: "E17055"),
    ]

    static let mathThirdGrade: [Topic] = [
        Topic(id: "place-value-100k", subject: .math, grade: .third, name: "Place Value to 100,000", teks: "3.2A", icon: "number", color: "0984E3"),
        Topic(id: "estimation-rounding", subject: .math, grade: .third, name: "Estimation & Rounding", teks: "3.4G", icon: "arrow.up.arrow.down.circle", color: "6C5CE7"),
        Topic(id: "add-sub-1000-3", subject: .math, grade: .third, name: "Add & Subtract within 1,000", teks: "3.4A", icon: "plusminus", color: "00CEC9"),
        Topic(id: "multiplication", subject: .math, grade: .third, name: "Multiplication Facts 0–12", teks: "3.4E", icon: "multiply", color: "2980B9"),
        Topic(id: "division", subject: .math, grade: .third, name: "Division Facts 0–12", teks: "3.4F", icon: "divide", color: "16A085"),
        Topic(id: "even-odd-3", subject: .math, grade: .third, name: "Even & Odd Patterns", teks: "3.4H", icon: "checkerboard.rectangle", color: "1ABC9C"),
        Topic(id: "number-patterns-3", subject: .math, grade: .third, name: "Number Patterns & Tables", teks: "3.5A", icon: "tablecells", color: "E67E22"),
        Topic(id: "arrays-area-model", subject: .math, grade: .third, name: "Arrays & Area Models", teks: "3.4C", icon: "square.grid.3x3", color: "D35400"),
        Topic(id: "two-step-word-problems", subject: .math, grade: .third, name: "Two-Step Word Problems", teks: "3.4J", icon: "text.append", color: "E84393"),
        Topic(id: "unit-fractions", subject: .math, grade: .third, name: "Unit Fractions", teks: "3.3C", icon: "1.circle", color: "FAB1A0"),
        Topic(id: "fractions-number-line", subject: .math, grade: .third, name: "Fractions on a Number Line", teks: "3.3A", icon: "chart.bar", color: "C0392B"),
        Topic(id: "equivalent-fractions", subject: .math, grade: .third, name: "Equivalent Fractions", teks: "3.3F", icon: "equal.circle", color: "FF7675"),
        Topic(id: "compare-fractions", subject: .math, grade: .third, name: "Comparing Fractions", teks: "3.3H", icon: "lessthan.circle", color: "8E44AD"),
        Topic(id: "elapsed-time", subject: .math, grade: .third, name: "Elapsed Time", teks: "3.7C", icon: "clock.arrow.circlepath", color: "2C3E50"),
        Topic(id: "perimeter-area", subject: .math, grade: .third, name: "Perimeter & Area", teks: "3.6C", icon: "square.dashed", color: "27AE60"),
        Topic(id: "shapes-3d-3", subject: .math, grade: .third, name: "3D Solids & Attributes", teks: "3.6A", icon: "cube.fill", color: "48DBFB"),
        Topic(id: "shapes-quadrilaterals", subject: .math, grade: .third, name: "Quadrilaterals & 2D Shapes", teks: "3.6B", icon: "diamond", color: "55EFC4"),
        Topic(id: "geo-measure-word-problems-3", subject: .math, grade: .third, name: "Geometry & Measurement Problems", teks: "3.7B", icon: "ruler.fill", color: "8E44AD"),
        Topic(id: "measurement-units-3", subject: .math, grade: .third, name: "Customary & Metric Units", teks: "3.7D", icon: "scalemass.fill", color: "636E72"),
        Topic(id: "data-graphs", subject: .math, grade: .third, name: "Data & Graphs", teks: "3.8A", icon: "chart.bar.xaxis", color: "E91E63"),
        Topic(id: "money-word-problems", subject: .math, grade: .third, name: "Money Word Problems", teks: "3.4K", icon: "dollarsign", color: "F39C12"),
        Topic(id: "financial-literacy-3", subject: .math, grade: .third, name: "Earn, Save, Spend & Donate", teks: "3.9A", icon: "banknote.fill", color: "FDCB6E"),
        Topic(id: "staar-mixed", subject: .math, grade: .third, name: "STAAR Mixed Review", teks: "3.all", icon: "star", color: "9B59B6"),
    ]

    static let scienceSecondGrade: [Topic] = [
        Topic(id: "sci-science-tools", subject: .science, grade: .second, name: "Science Tools & Safety", teks: "2.2A", icon: "wrench.and.screwdriver", color: "8E8E93"),
        Topic(id: "sci-scientific-method", subject: .science, grade: .second, name: "Scientific Method", teks: "2.2B", icon: "list.bullet.clipboard", color: "B2BEC3"),
        Topic(id: "sci-scientists-work", subject: .science, grade: .second, name: "Scientists & Science Practices", teks: "2.2C", icon: "person.crop.circle", color: "DFE6E9"),
        Topic(id: "sci-matter-properties", subject: .science, grade: .second, name: "Matter & Its Properties", teks: "2.5A", icon: "atom", color: "E8A838"),
        Topic(id: "sci-matter-changes", subject: .science, grade: .second, name: "Changes to Matter", teks: "2.5B", icon: "flame", color: "E8622A"),
        Topic(id: "sci-mixtures", subject: .science, grade: .second, name: "Mixtures & Solutions", teks: "2.5C", icon: "drop.triangle", color: "00CEC9"),
        Topic(id: "sci-force-motion", subject: .science, grade: .second, name: "Force & Motion", teks: "2.6A", icon: "arrow.right.circle", color: "5B8FE8"),
        Topic(id: "sci-energy-forms", subject: .science, grade: .second, name: "Forms of Energy", teks: "2.6B", icon: "bolt.circle", color: "F5C842"),
        Topic(id: "sci-vibration-sound", subject: .science, grade: .second, name: "Vibration & Sound", teks: "2.6C", icon: "speaker.wave.2", color: "A29BFE"),
        Topic(id: "sci-sound-light", subject: .science, grade: .second, name: "Sound & Light", teks: "2.6C", icon: "waveform", color: "9B59E8"),
        Topic(id: "sci-earth-materials", subject: .science, grade: .second, name: "Earth Materials", teks: "2.7A", icon: "mountain.2", color: "7DAE5A"),
        Topic(id: "sci-sky-patterns", subject: .science, grade: .second, name: "Patterns in the Sky", teks: "2.7B", icon: "sun.max", color: "F07A3A"),
        Topic(id: "sci-weather-seasons", subject: .science, grade: .second, name: "Weather & Seasons", teks: "2.7C", icon: "cloud.sun", color: "81ECEC"),
        Topic(id: "sci-severe-weather", subject: .science, grade: .second, name: "Severe Weather & Data", teks: "2.7C", icon: "tornado", color: "E17055"),
        Topic(id: "sci-conservation", subject: .science, grade: .second, name: "Resources & Conservation", teks: "2.7D", icon: "leaf.arrow.triangle.circlepath", color: "55A630"),
        Topic(id: "sci-plant-structures", subject: .science, grade: .second, name: "Plant Structures", teks: "2.8A", icon: "leaf", color: "3AAF6A"),
        Topic(id: "sci-animal-needs", subject: .science, grade: .second, name: "Animal Needs & Adaptations", teks: "2.8B", icon: "pawprint", color: "E85C8A"),
        Topic(id: "sci-life-cycles", subject: .science, grade: .second, name: "Life Cycles", teks: "2.8C", icon: "arrow.triangle.2.circlepath", color: "45C4B0"),
        Topic(id: "sci-food-chains", subject: .science, grade: .second, name: "Food Chains", teks: "2.8D", icon: "link", color: "F9CA24"),
        Topic(id: "sci-habitats", subject: .science, grade: .second, name: "Habitats & Environments", teks: "2.8E", icon: "tree", color: "5A9E6F"),
        Topic(id: "sci2-mixed-review", subject: .science, grade: .second, name: "2nd Grade Science Review", teks: "2.all", icon: "star.circle.fill", color: "9B59B6"),
    ]

    static let scienceThirdGrade: [Topic] = [
        Topic(id: "sci3-investigation", subject: .science, grade: .third, name: "Scientific Investigation", teks: "3.2A", icon: "flask", color: "A29BFE"),
        Topic(id: "sci3-science-practices", subject: .science, grade: .third, name: "Science Tools & Practices", teks: "3.2B", icon: "wrench.and.screwdriver", color: "B2BEC3"),
        Topic(id: "sci3-matter-states", subject: .science, grade: .third, name: "States of Matter & Mixtures", teks: "3.5A", icon: "humidity", color: "74B9FF"),
        Topic(id: "sci3-force-magnets", subject: .science, grade: .third, name: "Force, Motion & Magnets", teks: "3.6A", icon: "magnet", color: "0984E3"),
        Topic(id: "sci3-mechanical-energy", subject: .science, grade: .third, name: "Mechanical Energy & Speed", teks: "3.6A", icon: "gearshape.2", color: "F0932B"),
        Topic(id: "sci3-everyday-energy", subject: .science, grade: .third, name: "Light, Sound & Heat Energy", teks: "3.6B", icon: "sun.max.fill", color: "F5C842"),
        Topic(id: "sci3-energy-circuits", subject: .science, grade: .third, name: "Energy & Circuits", teks: "3.6B", icon: "bolt.fill", color: "FDCB6E"),
        Topic(id: "sci3-earth-soil", subject: .science, grade: .third, name: "Soils, Rocks & Landforms", teks: "3.7A", icon: "globe.americas", color: "6AB04C"),
        Topic(id: "sci3-conservation", subject: .science, grade: .third, name: "Resources & Conservation", teks: "3.7B", icon: "leaf.arrow.triangle.circlepath", color: "55A630"),
        Topic(id: "sci3-sun-moon", subject: .science, grade: .third, name: "Sun, Moon & Earth", teks: "3.8A", icon: "moon.stars", color: "F0932B"),
        Topic(id: "sci3-weather-climate", subject: .science, grade: .third, name: "Weather & Climate", teks: "3.8B", icon: "cloud.rain", color: "70A1FF"),
        Topic(id: "sci3-ecosystems", subject: .science, grade: .third, name: "Ecosystems & Food Webs", teks: "3.9A", icon: "globe.europe.africa", color: "38ADA9"),
        Topic(id: "sci3-fossils-changes", subject: .science, grade: .third, name: "Fossils & Ecosystem Changes", teks: "3.9B", icon: "hourglass", color: "D4A574"),
        Topic(id: "sci3-growth-behavior", subject: .science, grade: .third, name: "Growth & Behavior", teks: "3.10C", icon: "thermometer.sun", color: "E17055"),
        Topic(id: "sci3-inherited-traits", subject: .science, grade: .third, name: "Inherited Traits", teks: "3.10A", icon: "person.2", color: "EB4D4B"),
        Topic(id: "sci3-life-cycles", subject: .science, grade: .third, name: "Life Cycles", teks: "3.10B", icon: "ladybug", color: "BADC58"),
        Topic(id: "sci3-mixed-review", subject: .science, grade: .third, name: "3rd Grade Science Review", teks: "3.all", icon: "star.circle.fill", color: "9B59B6"),
    ]

    static let secondGrade: [Topic] = mathSecondGrade
    static let thirdGrade: [Topic] = mathThirdGrade

    static func topic(id: String) -> Topic? {
        all.first { $0.id == id }
    }

    static func topics(for grade: GradeLevel, subject: Subject) -> [Topic] {
        switch (subject, grade) {
        case (.math, .second): return mathSecondGrade + mathPOT2Topics
        case (.math, .third): return mathThirdGrade + mathPOT2Topics
        case (.science, .second): return scienceSecondGrade
        case (.science, .third): return scienceThirdGrade
        }
    }

    static func topics(for grade: GradeLevel) -> [Topic] {
        topics(for: grade, subject: .math)
    }

    static func grades(for subject: Subject) -> [GradeLevel] {
        switch subject {
        case .math, .science: return GradeLevel.allCases
        }
    }

    static var secondGradePracticeTopics: [Topic] {
        mathSecondGrade.filter { $0.id != "staar-mixed-2" }
    }

    static var thirdGradePracticeTopics: [Topic] {
        mathThirdGrade.filter { $0.id != "staar-mixed" }
    }

    static var scienceSecondGradePracticeTopics: [Topic] {
        scienceSecondGrade.filter { $0.id != "sci2-mixed-review" }
    }

    static var scienceThirdGradePracticeTopics: [Topic] {
        scienceThirdGrade.filter { $0.id != "sci3-mixed-review" }
    }
}
