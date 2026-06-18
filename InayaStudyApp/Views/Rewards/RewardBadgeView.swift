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
                            .background(AppTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button(action: onDismiss) {
                        Text("Awesome!")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(TopicAccent(topic: topic).color)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .background(AppTheme.background.ignoresSafeArea())
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

    var body: some View {
        ZStack {
            HexagonShape()
                .fill(TopicAccent(topic: topic).color.opacity(0.25))
                .frame(width: 120, height: 120)
            HexagonShape()
                .stroke(Color.yellow, lineWidth: 4)
                .frame(width: 120, height: 120)
            Image(systemName: topic.icon)
                .font(.largeTitle)
                .foregroundStyle(TopicAccent(topic: topic).color)
        }
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
