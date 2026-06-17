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

    static func random(for subject: Subject = .math) -> String {
        let pool = subject == .science ? sciencePhrases : mathPhrases
        return pool.randomElement() ?? "Great job!"
    }

    static func random() -> String {
        random(for: .math)
    }

    static func resultsMessage(stars: Int, subject: Subject = .math) -> String {
        switch (stars, subject) {
        case (3, .science): return "Amazing science work, Inaya! 🔬"
        case (3, _): return "Amazing work, Inaya! 🌟"
        case (_, .science): return "Great exploring, Inaya! Keep discovering!"
        case (2, _): return "Great job, Inaya! Keep going!"
        default: return "Nice try, Inaya! Practice makes perfect."
        }
    }

    static func stars(for accuracy: Double) -> Int {
        if accuracy >= 0.9 { return 3 }
        if accuracy >= 0.7 { return 2 }
        return 1
    }
}
