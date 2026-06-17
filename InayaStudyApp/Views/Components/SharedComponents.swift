import SwiftUI

struct ConfettiView: View {
    @State private var particles: [Particle] = []
    @State private var animate = false

    var body: some View {
        Canvas { context, size in
            for p in particles {
                let y = animate ? size.height + 20 : p.y
                let rect = CGRect(x: p.x, y: y, width: p.size, height: p.size)
                context.fill(Path(ellipseIn: rect), with: .color(p.color))
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            particles = (0..<60).map { _ in
                Particle(
                    x: CGFloat.random(in: 0...400),
                    y: CGFloat.random(in: -100...0),
                    size: CGFloat.random(in: 6...12),
                    color: [Color.yellow, .pink, .orange, .green, .blue].randomElement()!
                )
            }
            withAnimation(.easeIn(duration: 2.5)) { animate = true }
        }
    }

    private struct Particle {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let color: Color
    }
}

struct AccuracyRingView: View {
    let accuracy: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: accuracy)
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(accuracy * 100))%")
                .font(.caption2.bold())
        }
        .frame(width: 36, height: 36)
    }
}

struct StarRowView: View {
    let count: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: i < count ? "star.fill" : "star")
                    .font(.title)
                    .foregroundStyle(AppTheme.star)
            }
        }
    }
}
