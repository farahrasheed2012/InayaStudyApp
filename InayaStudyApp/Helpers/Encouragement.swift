import Foundation

enum Encouragement {
    static let mathPhrases = [
        "You got it!",
        "Brilliant!",
        "Math star!",
        "Keep it up, Inaya!",
        "Super smart!",
        "Way to go!",
        "Fantastic!",
        "You're on fire!",
        "So proud of you!",
        "Amazing work!",
        "High five!",
        "You rock!",
        "Great thinking!",
        "Wonderful!",
        "Star student!",
    ]

    static let sciencePhrases = [
        "Great scientist!",
        "You observed that perfectly!",
        "Lab partner approved!",
        "Discovery made! 🔬",
        "Super observation!",
        "Science star!",
        "Hypothesis confirmed!",
        "Curious mind!",
        "Experiment success!",
        "Nature expert!",
        "Sharp scientist!",
        "Investigation complete!",
        "You figured it out!",
        "Brilliant discovery!",
        "Future scientist!",
    ]

    static func random(for subject: Subject, name: String = "Inaya") -> String {
        let pool = (subject == .science ? sciencePhrases : mathPhrases)
            .map { $0.replacingOccurrences(of: "Inaya", with: name) }
        return pool.randomElement() ?? "Great job, \(name)!"
    }

    static func random() -> String {
        random(for: .math)
    }

    static func resultsMessage(stars: Int, subject: Subject = .math, name: String = "Inaya") -> String {
        switch (stars, subject) {
        case (3, .science): return "Amazing science work, \(name)! 🔬"
        case (3, _): return "Amazing work, \(name)! 🌟"
        case (2, .science): return "Great exploring, \(name)! Keep discovering!"
        case (2, _): return "Great job, \(name)! Keep going!"
        case (1, _): return "Nice try, \(name)! Practice makes perfect."
        default: return "Keep practicing, \(name)! You can do it!"
        }
    }

    static func stars(for accuracy: Double) -> Int {
        if accuracy >= 0.9 { return 3 }
        if accuracy >= 0.8 { return 2 }
        if accuracy >= 0.6 { return 1 }
        return 0
    }
}
