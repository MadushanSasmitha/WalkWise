import SwiftUI

struct HomeView: View {
    @EnvironmentObject var healthVM: HealthViewModel
    @EnvironmentObject var profileVM: ProfileViewModel

    var body: some View {
        GradientBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Greeting
                    Text("Hi, \(profileVM.profile?.displayName.split(separator: " ").first ?? "Walker") 👋")
                        .font(.title2).bold()
                    Text("Here’s how your walk looks today")
                        .font(.subheadline).foregroundStyle(.secondary)

                    // Today Summary Card
                    GradientCard(colors: [.teal.opacity(0.7), .cyan.opacity(0.7)]) {
                        HStack {
                            StepsRingView(
                                progress: progress,
                                steps: healthVM.todaySteps,
                                goal: goal
                            )
                            Spacer()
                            VStack(alignment: .leading, spacing: 8) {
                                Label("\(String(format: "%.1f", healthVM.todayDistanceKm)) km", systemImage: "map")
                                Label("\(healthVM.todayMinutes) min", systemImage: "clock")
                            }
                            .font(.headline)
                        }
                    }

                    // ML Insight
                    GradientCard(colors: [Color.purple.opacity(0.5), Color.mint.opacity(0.5)]) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(mlTitle).font(.headline)
                            Text(mlSubtitle).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }

                    // Graphs
                    VStack(alignment: .leading, spacing: 12) {
                        Text("7-day steps").font(.headline)
                        BarChartView(values: steps7, highlightIndex: steps7.count - 1)
                        Text("7-day walking minutes").font(.headline)
                        LineChartView(values: minutes7)
                    }

                    // Quick actions
                    HStack {
                        NavigationLink(destination: ProfileView()) {
                            Label("Adjust daily goal", systemImage: "target")
                                .padding()
                                .background(.thinMaterial)
                                .cornerRadius(12)
                        }
                        Spacer()
                        NavigationLink(destination: SessionsView()) {
                            Label("View sessions", systemImage: "list.bullet")
                                .padding()
                                .background(.thinMaterial)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Today")
        }
    }

    private var goal: Int { Int(profileVM.profile?.dailyStepGoal ?? 8000) }
    private var progress: Double { goal == 0 ? 0 : Double(healthVM.todaySteps) / Double(goal) }

    private var steps7: [Int] { healthVM.last7DaysSummaries.map { Int($0.totalSteps) } }
    private var minutes7: [Int] { healthVM.last7DaysSummaries.map { Int($0.walkingMinutes) } }

    private var mlTitle: String { healthVM.mlLabelToday.isEmpty ? "Insight unavailable" : healthVM.mlLabelToday }
    private var mlSubtitle: String {
        switch healthVM.mlLabelToday {
        case "Above average": return "You're ahead of your typical pace today."
        case "On track": return "You're keeping up with your goal."
        case "Below usual": return "A short walk now could put you back on track."
        default: return "We'll learn your pattern soon."
        }
    }
}
