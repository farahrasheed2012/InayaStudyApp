import SwiftUI

extension View {
    @ViewBuilder
    func quizKeyboardShortcuts(viewModel: QuizViewModel, onHint: @escaping () -> Void) -> some View {
        #if targetEnvironment(macCatalyst)
        if #available(iOS 17.0, macOS 14.0, *) {
            modifier(QuizKeyboardShortcutsModifier(viewModel: viewModel, onHint: onHint))
        } else {
            self
        }
        #else
        self
        #endif
    }
}

#if targetEnvironment(macCatalyst)
@available(iOS 17.0, macOS 14.0, *)
private struct QuizKeyboardShortcutsModifier: ViewModifier {
    @ObservedObject var viewModel: QuizViewModel
    var onHint: () -> Void

    func body(content: Content) -> some View {
        content
            .onKeyPress(.return) {
                if viewModel.showingFeedback {
                    viewModel.continueEarly()
                } else if viewModel.currentProblem?.answerType == .numberEntry {
                    viewModel.submitCurrentInput()
                }
                return .handled
            }
            .onKeyPress(characters: CharacterSet(charactersIn: "1234")) { press in
                guard !viewModel.showingFeedback,
                      let problem = viewModel.currentProblem,
                      problem.answerType != .numberEntry else { return .ignored }
                let choices = problem.choices ?? problem.tapOptions ?? []
                let map: [Character: Int] = ["1": 0, "2": 1, "3": 2, "4": 3]
                guard let char = press.characters.first,
                      let index = map[char],
                      index < choices.count else { return .ignored }
                viewModel.submitAnswer(choices[index])
                return .handled
            }
            .onKeyPress("h") {
                onHint()
                return .handled
            }
            .onKeyPress("H") {
                onHint()
                return .handled
            }
    }
}
#endif
