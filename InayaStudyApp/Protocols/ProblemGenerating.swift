import Foundation

protocol ProblemGenerating {
    var subject: Subject { get }
    func generate(difficulty: Difficulty) -> Problem
    func generateSession(difficulty: Difficulty, count: Int) -> [Problem]
}

extension ProblemGenerating {
    func generateSession(difficulty: Difficulty, count: Int) -> [Problem] {
        var seen = Set<String>()
        var results: [Problem] = []
        var attempts = 0
        while results.count < count && attempts < count * 30 {
            let problem = generate(difficulty: difficulty)
            if seen.insert(problem.questionText).inserted {
                results.append(problem)
            }
            attempts += 1
        }
        while results.count < count {
            results.append(generate(difficulty: difficulty))
        }
        return results
    }
}

struct TopicProblemGenerator: ProblemGenerating {
    let topic: Topic

    var subject: Subject { topic.subject }

    func generate(difficulty: Difficulty) -> Problem {
        if topic.subject == .science {
            return ScienceProblemGenerator.generate(topic: topic, difficulty: difficulty)
        }
        return ProblemGenerator.generate(topic: topic, difficulty: difficulty)
    }
}

enum ProblemGeneratorFactory {
    static func make(for topic: Topic) -> any ProblemGenerating {
        switch topic.subject {
        case .math:
            return MathProblemGenerator(topic: topic)
        case .science:
            return ScienceProblemGeneratorEngine(topic: topic)
        }
    }
}
