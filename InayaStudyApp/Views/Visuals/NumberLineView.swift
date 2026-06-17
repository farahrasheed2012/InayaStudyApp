import SwiftUI

struct NumberLineView: View {
    let min: Int
    let max: Int
    let marked: [Int]

    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let y = size.height / 2
                var line = Path()
                line.move(to: CGPoint(x: 20, y: y))
                line.addLine(to: CGPoint(x: size.width - 20, y: y))
                context.stroke(line, with: .color(.primary), lineWidth: 2)
                for m in marked {
                    let x = xPosition(for: m, width: size.width)
                    var marker = Path()
                    marker.move(to: CGPoint(x: x, y: y - 12))
                    marker.addLine(to: CGPoint(x: x, y: y + 12))
                    context.stroke(marker, with: .color(.red), lineWidth: 3)
                    if animate {
                        let dot = Path(ellipseIn: CGRect(x: x - 6, y: y - 6, width: 12, height: 12))
                        context.fill(dot, with: .color(.red))
                    }
                }
                context.draw(Text("0").font(.caption), at: CGPoint(x: 20, y: y + 20))
                context.draw(Text("1").font(.caption), at: CGPoint(x: size.width - 20, y: y + 20))
            }
        }
        .frame(height: 80)
        .onAppear {
            withAnimation(.spring(duration: 0.5)) { animate = true }
        }
    }

    private func xPosition(for value: Int, width: CGFloat) -> CGFloat {
        let range = CGFloat(max - min)
        guard range > 0 else { return width / 2 }
        return 20 + (CGFloat(value - min) / range) * (width - 40)
    }
}
