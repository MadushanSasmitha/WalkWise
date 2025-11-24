import SwiftUI

struct BarChartView: View {
    var values: [Int]
    var highlightIndex: Int?

    var maxValue: Double { Double(values.max() ?? 1) }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(values.indices), id: \.self) { i in
                let v = Double(values[i])
                Rectangle()
                    .fill(i == highlightIndex ? Color.teal : Color.cyan.opacity(0.8))
                    .frame(height: CGFloat((v / maxValue)) * 120)
                    .cornerRadius(6)
            }
        }.frame(height: 140)
    }
}
