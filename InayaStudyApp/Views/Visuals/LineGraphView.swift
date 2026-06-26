import SwiftUI

struct LineGraphView: View {
    let labels: [String]
    let values: [Int]

    var body: some View {
        GeometryReader { geo in
            let maxVal = max(values.max() ?? 1, 1)
            let width = geo.size.width - 32
            let height = geo.size.height - 40
            let stepX = labels.count > 1 ? width / CGFloat(labels.count - 1) : width

            ZStack(alignment: .bottomLeading) {
                Path { path in
                    for (index, value) in values.enumerated() {
                        let x = 16 + CGFloat(index) * stepX
                        let y = 20 + height - (CGFloat(value) / CGFloat(maxVal)) * height
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 3, lineJoin: .round))

                ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                    let x = 16 + CGFloat(index) * stepX
                    let y = 20 + height - (CGFloat(value) / CGFloat(maxVal)) * height
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                }

                HStack(spacing: 0) {
                    ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                        Text(label)
                            .font(.caption2)
                            .frame(width: labels.count > 1 ? stepX : width)
                    }
                }
                .offset(y: height + 12)
                .padding(.leading, 8)
            }
        }
        .frame(height: 180)
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Line graph")
        .accessibilityValue(zip(labels, values).map { "\($0.0) \($0.1)" }.joined(separator: ", "))
    }
}
