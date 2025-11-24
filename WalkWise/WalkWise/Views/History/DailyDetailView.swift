import SwiftUI

struct DailyDetailView: View {
    let summary: DailySummary

    var body: some View {
        GradientBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    GradientCard(colors: [.teal.opacity(0.7), .cyan.opacity(0.7)]) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(summary.date, style: .date).font(.headline)
                            Text("\(summary.totalSteps) steps").font(.title).bold()
                            HStack(spacing: 16) {
                                Label(String(format: "%.1f km", summary.totalDistanceKm), systemImage: "map")
                                Label("\(summary.walkingMinutes) min", systemImage: "clock")
                            }.font(.headline)
                        }
                    }

                    GradientCard(colors: [Color.purple.opacity(0.5), Color.mint.opacity(0.5)]) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(summary.mlLabel ?? "Insight coming soon").font(.headline)
                            Text("Compared with your recent days. This is a simple heuristic label.")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hourly distribution (example)").font(.headline)
                        HStack(alignment: .bottom, spacing: 6) {
                            ForEach(0..<12, id: \.self) { _ in
                                Rectangle().fill(Color.cyan.opacity(0.8)).frame(width: 10, height: CGFloat(Int.random(in: 10...80)))
                            }
                        }.frame(height: 100)
                    }
                }
                .padding()
            }
            .navigationTitle("Day Detail")
        }
    }
}
