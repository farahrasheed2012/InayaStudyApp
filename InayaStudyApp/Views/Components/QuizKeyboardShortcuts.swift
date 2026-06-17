import SwiftUI

extension View {
    @ViewBuilder
    func quizKeyboardShortcuts(viewModel: QuizViewModel) -> some View {
        #if targetEnvironment(macCatalyst)
        if #available(iOS 17.0, macOS 14.0, *) {
            modifier(QuizKeyboardShortcutsModifier(viewModel: viewModel))
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
            .onKeyPress(.space) {
                if viewModel.showingFeedback {
                    viewModel.continueEarly()
                }
                return .handled
            }
    }
}
#endif
