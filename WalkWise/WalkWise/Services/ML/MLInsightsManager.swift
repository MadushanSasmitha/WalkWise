import Foundation

// MLInsightsManager provides a simple heuristic-based label now, but keeps a Core ML-like interface
// so it can be swapped with a real .mlmodel later.
final class MLInsightsManager {
    static let shared = MLInsightsManager()
    private init() {}

    // Returns: "On track", "Below usual", or "Above average"
    func label(todaySteps: Int, dailyGoal: Int, last7Days: [Int]) -> String {
        let avg = last7Days.isEmpty ? 0 : last7Days.reduce(0, +) / max(1, last7Days.count)
        let goalRatio = dailyGoal == 0 ? 0 : Double(todaySteps) / Double(dailyGoal)
        let avgRatio = avg == 0 ? 0 : Double(todaySteps) / Double(avg)

        if goalRatio >= 1.05 || avgRatio >= 1.2 { return "Above average" }
        if goalRatio >= 0.8 && avgRatio >= 0.9 { return "On track" }
        return "Below usual"
    }
}
