import SwiftUI

struct LineChartView: View {
    var values: [Int]

    var maxValue: Double { Double(values.max() ?? 1) }

    var body: some View {
        GeometryReader { geo in
            Path { path in
                guard !values.isEmpty else { return }
                let w = geo.size.width
                let h = geo.size.height
                let stepX = w / CGFloat(max(values.count - 1, 1))
                for (i, v) in values.enumerated() {
                    let x = CGFloat(i) * stepX
                    let y = h - CGFloat(Double(v) / maxValue) * (h - 4)
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(LinearGradient(colors: [.purple, .mint], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 3, lineJoin: .round))
        }
        .frame(height: 140)
    }
}
