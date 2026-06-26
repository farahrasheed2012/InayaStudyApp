import SwiftUI

struct VennDiagramView: View {
    enum Style {
        case twoCircle(onlyA: Int, onlyB: Int, both: Int, labelA: String, labelB: String)
        case threeCircle(
            onlyA: Int, onlyB: Int, onlyC: Int,
            ab: Int, ac: Int, bc: Int, abc: Int,
            labelA: String, labelB: String, labelC: String
        )
    }

    let style: Style

    var body: some View {
        switch style {
        case .twoCircle(let onlyA, let onlyB, let both, let labelA, let labelB):
            twoCircleView(onlyA: onlyA, onlyB: onlyB, both: both, labelA: labelA, labelB: labelB)
        case .threeCircle(let onlyA, let onlyB, let onlyC, let ab, let ac, let bc, let abc, let labelA, let labelB, let labelC):
            threeCircleView(
                onlyA: onlyA, onlyB: onlyB, onlyC: onlyC,
                ab: ab, ac: ac, bc: bc, abc: abc,
                labelA: labelA, labelB: labelB, labelC: labelC
            )
        }
    }

    private func twoCircleView(onlyA: Int, onlyB: Int, both: Int, labelA: String, labelB: String) -> some View {
        ZStack {
            HStack(spacing: -40) {
                circleRegion(count: onlyA + both, color: .blue.opacity(0.25), label: labelA)
                circleRegion(count: onlyB + both, color: .orange.opacity(0.25), label: labelB)
            }
            VStack(spacing: 8) {
                HStack(spacing: 48) {
                    countBadge(onlyA, title: "\(labelA) only")
                    countBadge(onlyB, title: "\(labelB) only")
                }
                countBadge(both, title: "Both")
            }
        }
        .frame(height: 160)
        .padding()
    }

    private func threeCircleView(
        onlyA: Int, onlyB: Int, onlyC: Int,
        ab: Int, ac: Int, bc: Int, abc: Int,
        labelA: String, labelB: String, labelC: String
    ) -> some View {
        VStack(spacing: 10) {
            Text("\(labelA) · \(labelB) · \(labelC)")
                .font(.caption.weight(.semibold))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                regionCell("\(labelA) only", onlyA)
                regionCell("\(labelB) only", onlyB)
                regionCell("\(labelC) only", onlyC)
                regionCell("All three", abc)
                regionCell("\(labelA) & \(labelB)", ab)
                regionCell("\(labelA) & \(labelC)", ac)
                regionCell("\(labelB) & \(labelC)", bc)
            }
        }
        .padding()
    }

    private func circleRegion(count: Int, color: Color, label: String) -> some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 120, height: 120)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .accessibilityLabel("\(label), total shown \(count)")
    }

    private func countBadge(_ value: Int, title: String) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.headline)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private func regionCell(_ title: String, _ value: Int) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title3.bold())
            Text(title)
                .font(.caption2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CubeStackView: View {
    let rows: Int
    let cols: Int
    let hidden: Int

    var body: some View {
        let visible = rows * cols
        VStack(spacing: 8) {
            VStack(spacing: 4) {
                ForEach((0..<rows).reversed(), id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<cols, id: \.self) { col in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.accentColor.opacity(row == 0 && col == cols - 1 ? 0.35 : 0.75))
                                .frame(width: 28, height: 28)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                }
            }
            if hidden > 0 {
                Text("+\(hidden) hidden cube\(hidden == 1 ? "" : "s") behind")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text("Visible: \(visible)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .accessibilityLabel("Cube stack \(rows) by \(cols) with \(hidden) hidden cubes")
    }
}
