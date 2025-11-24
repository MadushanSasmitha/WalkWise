import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var healthVM: HealthViewModel
    @EnvironmentObject var profileVM: ProfileViewModel

    var body: some View {
        GradientBackgroundView {
            List {
                ForEach(healthVM.last7DaysSummaries, id: \.id) { s in
                    NavigationLink(destination: DailyDetailView(summary: s)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(s.date, style: .date).font(.headline)
                                Text("\(s.totalSteps) steps • \(String(format: "%.1f", s.totalDistanceKm)) km • \(s.walkingMinutes) min")
                                    .font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(badge(for: s))
                                .padding(8)
                                .background(badgeColor(for: s))
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("History")
        }
    }

    private func badge(for s: DailySummary) -> String { s.goalReached ? "Goal" : (Int(s.totalSteps) >= goal - 1000 ? "Close" : "Low") }
    private func badgeColor(for s: DailySummary) -> Color { s.goalReached ? .green : (Int(s.totalSteps) >= goal - 1000 ? .orange : .red) }
    private var goal: Int { Int(profileVM.profile?.dailyStepGoal ?? 8000) }
}
