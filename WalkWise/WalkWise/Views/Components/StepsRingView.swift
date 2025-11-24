import SwiftUI

struct StepsRingView: View {
    var progress: Double // 0...1
    var steps: Int
    var goal: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 16)
            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(AngularGradient(gradient: Gradient(colors: [.teal, .cyan]), center: .center), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            VStack(spacing: 4) {
                Text("\(steps) steps").font(.headline)
                Text("Goal: \(goal)").font(.caption).foregroundStyle(.secondary)
            }
        }.frame(width: 140, height: 140)
    }
}
