import SwiftUI

struct ClockFaceView: View {
    let hour: Int
    let minute: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.primary, lineWidth: 3)
            ForEach(0..<12, id: \.self) { i in
                tickMark(index: i)
            }
            hand(length: 50, width: 5, angle: hourAngle)
            hand(length: 72, width: 3, angle: minuteAngle)
        }
        .frame(width: 180, height: 180)
        .accessibilityLabel("Clock showing \(ProblemGenerator.formatTime(hour: hour, minute: minute))")
    }

    private var minuteAngle: Angle {
        .degrees((Double(minute) / 60.0 + Double(hour % 12) / 12.0) * 360 - 90)
    }

    private var hourAngle: Angle {
        .degrees((Double(hour % 12) / 12.0 + Double(minute) / 720.0) * 360 - 90)
    }

    private func tickMark(index: Int) -> some View {
        Rectangle()
            .fill(Color.secondary)
            .frame(width: 2, height: 10)
            .offset(y: -78)
            .rotationEffect(.degrees(Double(index) * 30))
    }

    private func hand(length: CGFloat, width: CGFloat, angle: Angle) -> some View {
        RoundedRectangle(cornerRadius: width / 2)
            .fill(Color.primary)
            .frame(width: width, height: length)
            .offset(y: -length / 2)
            .rotationEffect(angle)
    }
}
