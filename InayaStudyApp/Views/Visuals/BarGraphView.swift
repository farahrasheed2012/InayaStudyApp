import SwiftUI

struct BarGraphView: View {
    let data: [(label: String, value: Int)]

    @State private var progress: CGFloat = 0

    var body: some View {
        let maxVal = max(data.map(\.value).max() ?? 1, 1)
        HStack(alignment: .bottom, spacing: 16) {
            ForEach(Array(data.enumerated()), id: \.offset) { _, item in
                VStack {
                    Text("\(item.value)")
                        .font(.caption2)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor.opacity(0.8))
                        .frame(width: 36, height: CGFloat(item.value) / CGFloat(maxVal) * 120 * progress)
                    Text(item.label)
                        .font(.caption2)
                        .lineLimit(1)
                }
            }
        }
        .frame(height: 160)
        .padding()
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { progress = 1 }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Bar graph")
        .accessibilityValue(data.map { "\($0.label) \($0.value)" }.joined(separator: ", "))
    }
}

struct RectangleDiagramView: View {
    let width: Int
    let height: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primary, lineWidth: 2)
                .frame(width: CGFloat(width) * 12 + 40, height: CGFloat(height) * 12 + 40)
            VStack {
                Text("\(height)")
                    .font(.caption)
                HStack {
                    Text("\(width)")
                        .font(.caption)
                    Spacer()
                }
            }
            .frame(width: CGFloat(width) * 12 + 20, height: CGFloat(height) * 12 + 20)
        }
        .padding()
    }
}
