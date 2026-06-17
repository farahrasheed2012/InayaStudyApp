import SwiftUI

struct FractionCircleView: View {
    let numerator: Int
    let denominator: Int

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 4
            let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
            for i in 0..<denominator {
                let start = Double(i) / Double(denominator) * 2 * .pi - .pi / 2
                let end = Double(i + 1) / Double(denominator) * 2 * .pi - .pi / 2
                var slice = Path()
                slice.move(to: center)
                slice.addArc(center: center, radius: radius, startAngle: .radians(start), endAngle: .radians(end), clockwise: false)
                slice.closeSubpath()
                let filled = i < numerator
                context.fill(slice, with: .color(filled ? .orange : .gray.opacity(0.2)))
                context.stroke(slice, with: .color(.primary), lineWidth: 1)
            }
        }
        .frame(width: 140, height: 140)
    }
}
