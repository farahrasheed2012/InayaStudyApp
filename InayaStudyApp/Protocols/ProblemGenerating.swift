import Foundation

protocol ProblemGenerating {
    var subject: Subject { get }
    func generate(difficulty: Difficulty) -> Problem
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
