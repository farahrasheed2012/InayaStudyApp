import SwiftUI

struct NumberLineView: View {
    let rangeMin: Int
    let rangeMax: Int
    let marked: [Int]

    private let horizontalPadding: CGFloat = 24

    private var isUnitFractionLine: Bool {
        rangeMin == 0 && rangeMax == 100
    }

    private var tickValues: [Int] {
        if isUnitFractionLine {
            return [0, 25, 50, 75, 100]
        }
        let range = rangeMax - rangeMin
        guard range > 0 else { return [rangeMin, rangeMax] }
        let step = tickStep(for: range)
        var values: [Int] = []
        var value = (rangeMin / step) * step
        if value < rangeMin { value += step }
        while value <= rangeMax {
            values.append(value)
            value += step
        }
        if values.first != rangeMin { values.insert(rangeMin, at: 0) }
        if values.last != rangeMax { values.append(rangeMax) }
        return values
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let lineY = geo.size.height * 0.42

            ZStack(alignment: .topLeading) {
                Path { path in
                    path.move(to: CGPoint(x: horizontalPadding, y: lineY))
                    path.addLine(to: CGPoint(x: width - horizontalPadding, y: lineY))
                }
                .stroke(Color.primary.opacity(0.85), lineWidth: 3)

                ForEach(tickValues, id: \.self) { tick in
                    let x = xPosition(for: tick, width: width)
                    TickMarkView(
                        x: x,
                        lineY: lineY,
                        label: tickLabel(for: tick)
                    )
                }

                ForEach(marked, id: \.self) { value in
                    let x = xPosition(for: value, width: width)
                    MarkedPointView(x: x, lineY: lineY)
                }
            }
        }
        .frame(height: 96)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityValue(markedAccessibilityValue)
    }

    private func xPosition(for value: Int, width: CGFloat) -> CGFloat {
        let range = CGFloat(rangeMax - rangeMin)
        guard range > 0 else { return width / 2 }
        let usable = width - horizontalPadding * 2
        return horizontalPadding + (CGFloat(value - rangeMin) / range) * usable
    }

    private func tickStep(for range: Int) -> Int {
        switch range {
        case ...20: return 1
        case ...50: return 5
        case ...120: return 10
        case ...250: return 25
        case ...600: return 50
        case ...1200: return 100
        default: return max(100, range / 6)
        }
    }

    private func tickLabel(for tick: Int) -> String {
        if isUnitFractionLine {
            switch tick {
            case 0: return "0"
            case 25: return "1/4"
            case 50: return "1/2"
            case 75: return "3/4"
            case 100: return "1"
            default: return "\(tick)"
            }
        }
        return "\(tick)"
    }

    private var accessibilityLabelText: String {
        if isUnitFractionLine {
            return "Number line from 0 to 1"
        }
        return "Number line from \(rangeMin) to \(rangeMax)"
    }

    private var markedAccessibilityValue: String {
        guard !marked.isEmpty else { return "No numbers marked" }
        if isUnitFractionLine {
            return "Marked at fraction position \(marked.map(String.init).joined(separator: ", ")) out of 100"
        }
        return "Marked at \(marked.map(String.init).joined(separator: ", "))"
    }
}

private struct TickMarkView: View {
    let x: CGFloat
    let lineY: CGFloat
    let label: String

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: x, y: lineY - 10))
                path.addLine(to: CGPoint(x: x, y: lineY + 10))
            }
            .stroke(Color.primary.opacity(0.55), lineWidth: 2)

            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .position(x: x, y: lineY + 28)
        }
    }
}

private struct MarkedPointView: View {
    let x: CGFloat
    let lineY: CGFloat

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: x, y: lineY - 16))
                path.addLine(to: CGPoint(x: x, y: lineY + 16))
            }
            .stroke(Color.red, lineWidth: 3)

            Circle()
                .fill(Color.red)
                .frame(width: 14, height: 14)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .position(x: x, y: lineY)
        }
    }
}
