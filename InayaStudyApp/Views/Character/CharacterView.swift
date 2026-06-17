import SwiftUI

struct CharacterView: View {
    var mood: SparkyMood
    var size: CGFloat = 72
    var speechText: String? = nil
    var onTap: (() -> Void)? = nil

    @Environment(\.colorScheme) private var colorScheme
    @State private var bob = false
    @State private var spin = false
    @State private var bounce = false

    private var bodyColor: Color {
        colorScheme == .dark ? Color(red: 0.2, green: 0.55, blue: 0.5) : Color(red: 0.27, green: 0.77, blue: 0.69)
    }

    var body: some View {
        VStack(spacing: 4) {
            if let text = speechText ?? mood.speechBubble {
                Text(text)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                    .transition(.scale.combined(with: .opacity))
            }

            sparkyBody
                .frame(width: size, height: size * 1.15)
                .offset(y: mood == .idle || mood == .sleeping ? (bob ? -3 : 3) : (bounce ? -8 : 0))
                .rotationEffect(.degrees(mood == .celebrating && spin ? 360 : (mood == .thinking ? -8 : 0)))
                .onTapGesture {
                    onTap?()
                }
                .accessibilityLabel("Sparky the robot")
        }
        .onAppear { startAnimations() }
        .onChange(of: mood) { _ in startAnimations() }
    }

    private var sparkyBody: some View {
        ZStack {
            if mood == .celebrating || mood == .excited {
                ForEach(0..<6, id: \.self) { i in
                    Image(systemName: mood == .celebrating ? "sparkle" : "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                        .offset(
                            x: cos(Double(i) * .pi / 3) * (bounce ? 28 : 18),
                            y: sin(Double(i) * .pi / 3) * (bounce ? 28 : 18)
                        )
                        .opacity(bounce ? 1 : 0.4)
                }
            }

            if mood == .thinking {
                Text("?")
                    .font(.title3.bold())
                    .foregroundStyle(.orange)
                    .offset(x: size * 0.42, y: -size * 0.35)
            }

            if mood == .encouraging {
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundStyle(.pink)
                    .offset(x: size * 0.35, y: -size * 0.45)
                    .offset(y: bounce ? -12 : 0)
            }

            if mood == .sleeping {
                Text("Zzz")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .offset(x: size * 0.3, y: -size * 0.4)
            }

            // Antenna
            VStack(spacing: 0) {
                Circle()
                    .fill(mood == .sleeping ? Color.gray : Color.yellow)
                    .frame(width: size * 0.12, height: size * 0.12)
                    .shadow(color: .yellow.opacity(mood == .sleeping ? 0 : 0.6), radius: 4)
                Rectangle()
                    .fill(bodyColor.opacity(0.8))
                    .frame(width: 2, height: size * 0.12)
            }
            .offset(y: -size * 0.52)

            // Arms
            HStack(spacing: size * 0.52) {
                arm(raised: mood == .excited || mood == .celebrating)
                arm(raised: mood == .excited || mood == .celebrating, mirrored: true)
            }
            .offset(y: -size * 0.05)

            // Body
            RoundedRectangle(cornerRadius: size * 0.18)
                .fill(bodyColor)
                .frame(width: size * 0.62, height: size * 0.55)
                .overlay(eyes)
                .offset(y: size * 0.02)

            // Legs
            HStack(spacing: size * 0.14) {
                leg
                leg
            }
            .offset(y: size * 0.38)
        }
    }

    private var eyes: some View {
        HStack(spacing: size * 0.14) {
            eye
            eye
        }
        .offset(y: -size * 0.04)
    }

    private var eye: some View {
        ZStack {
            Circle().fill(.white).frame(width: size * 0.14, height: size * 0.14)
            if mood == .sleeping {
                Capsule()
                    .fill(bodyColor.opacity(0.9))
                    .frame(width: size * 0.12, height: 2)
            } else {
                Circle()
                    .fill(Color.primary.opacity(0.8))
                    .frame(width: size * 0.06, height: size * 0.06)
                    .offset(x: mood == .thinking ? 2 : 0)
            }
        }
    }

    private func arm(raised: Bool, mirrored: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(bodyColor.opacity(0.9))
            .frame(width: size * 0.1, height: size * 0.22)
            .rotationEffect(.degrees(raised ? (mirrored ? 40 : -40) : (mirrored ? 15 : -15)))
    }

    private var leg: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(bodyColor.opacity(0.85))
            .frame(width: size * 0.12, height: size * 0.16)
    }

    private func startAnimations() {
        bob = false
        bounce = false
        spin = false

        switch mood {
        case .idle, .sleeping:
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) { bob = true }
        case .excited, .encouraging:
            withAnimation(.spring(response: 0.35, dampingFraction: 0.45)) { bounce = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { bounce = false }
        case .celebrating:
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) { bounce = true }
            withAnimation(.easeInOut(duration: 0.8)) { spin = true }
        default:
            break
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        ForEach(SparkyMood.allCases, id: \.self) { mood in
            CharacterView(mood: mood)
        }
    }
    .padding()
}
