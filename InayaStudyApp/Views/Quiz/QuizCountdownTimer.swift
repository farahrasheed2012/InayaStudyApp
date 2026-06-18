import SwiftUI

struct QuizCountdownTimer: View {
    let totalSeconds: Int
    let accent: Color
    let onExpired: () -> Void

    @State private var remaining: Int
    @State private var timerTask: Task<Void, Never>?

    init(totalSeconds: Int, accent: Color, onExpired: @escaping () -> Void) {
        self.totalSeconds = totalSeconds
        self.accent = accent
        self.onExpired = onExpired
        _remaining = State(initialValue: totalSeconds)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(remaining <= 5 ? AppTheme.danger : accent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: remaining)
            Text("\(remaining)")
                .font(AppTypography.sectionTitle)
        }
        .frame(width: 64, height: 64)
        .accessibilityLabel("Time remaining")
        .accessibilityValue("\(remaining) seconds")
        .onAppear { startTimer() }
        .onDisappear { timerTask?.cancel() }
        .onChange(of: totalSeconds) { _ in
            remaining = totalSeconds
            startTimer()
        }
    }

    private var progress: CGFloat {
        guard totalSeconds > 0 else { return 0 }
        return CGFloat(remaining) / CGFloat(totalSeconds)
    }

    private func startTimer() {
        timerTask?.cancel()
        remaining = totalSeconds
        timerTask = Task {
            while remaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    remaining -= 1
                    if remaining <= 0 {
                        onExpired()
                    }
                }
            }
        }
    }
}
