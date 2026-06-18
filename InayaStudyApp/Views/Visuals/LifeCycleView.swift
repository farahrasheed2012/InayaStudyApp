import SwiftUI

struct LifeCycleView: View {
    let kind: String
    let stages: [String]

    var body: some View {
        VStack(spacing: 12) {
            Text(kind.capitalized)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            HStack(spacing: 4) {
                ForEach(Array(stages.enumerated()), id: \.offset) { index, stage in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(Color.accentColor.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text("\(index + 1)")
                                    .font(.caption.bold())
                            )
                        Text(stage)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .frame(width: 64)
                    }
                    if index < stages.count - 1 {
                        Image(systemName: "arrow.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(kind) life cycle")
        .accessibilityValue(stages.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: ", "))
    }
}
