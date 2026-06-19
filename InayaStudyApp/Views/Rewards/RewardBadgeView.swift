import SwiftUI

struct RewardBadgeView: View {
    let topic: Topic
    let accuracy: Double
    let studentName: String
    var onDismiss: () -> Void

    @State private var showContent = false

    var body: some View {
        ZStack {
            ConfettiView()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                CharacterView(mood: .celebrating, size: 96)

                Text("New Badge Unlocked! 🏆")
                    .font(.title.bold())

                HexBadgeView(topic: topic)
                    .scaleEffect(showContent ? 1 : 0.3)
                    .opacity(showContent ? 1 : 0)

                Text("\(topic.name) Master")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text("\(Int(accuracy * 100))% accuracy")
                    .foregroundStyle(.secondary)

                HStack(spacing: 16) {
                    ShareLink(
                        item: "I earned the \(topic.name) Master badge on Inaya Study App! 🏆",
                        subject: Text("My new badge!"),
                        message: Text("I earned the \(topic.name) Master badge!")
                    ) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .appSurfaceCard(cornerRadius: 14)
                    }

                    Button(action: onDismiss) {
                        Text("Awesome!")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(AppTheme.color(hex: "5B8DEF"))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .appTappableStyle()
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .appScreenBackground()
        .preferredColorScheme(.light)
        .onAppear {
            SoundEffects.playBadgeUnlocked()
            Haptics.badgeUnlocked()
            SpeechManager.shared.speakBadgeUnlock(topicName: topic.name, name: studentName)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
                showContent = true
            }
        }
    }
}

struct HexBadgeView: View {
    let topic: Topic
    var compact: Bool = false

    private var accent: Color { TopicAccent(topic: topic).color }
    private var size: CGFloat { compact ? 72 : 120 }
    private var iconFont: Font { compact ? .title2 : .largeTitle }

    var body: some View {
        ZStack {
            HexagonShape()
                .fill(
                    LinearGradient(
                        colors: [.white, AppTheme.color(hex: "F8FBFF")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: accent.opacity(0.15), radius: compact ? 4 : 8, y: compact ? 2 : 4)

            HexagonShape()
                .stroke(Color.yellow.opacity(0.85), lineWidth: compact ? 2.5 : 3.5)

            HexagonShape()
                .scale(compact ? 0.82 : 0.85)
                .stroke(accent.opacity(0.35), lineWidth: compact ? 1.5 : 2)

            ZStack {
                Circle()
                    .fill(accent.opacity(0.12))
                    .frame(width: size * 0.52, height: size * 0.52)
                Image(systemName: topic.icon)
                    .font(iconFont)
                    .foregroundStyle(accent)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .frame(width: size, height: size)
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}
