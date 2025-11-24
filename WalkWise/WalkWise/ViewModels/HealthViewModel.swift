import Foundation
import Combine
import CoreData

@MainActor
final class HealthViewModel: ObservableObject {
    @Published var todaySteps: Int = 0
    @Published var todayDistanceKm: Double = 0
    @Published var todayMinutes: Int = 0
    @Published var last7DaysSummaries: [DailySummary] = []
    @Published var mlLabelToday: String = ""

    private let health = HealthManager.shared
    private let ml = MLInsightsManager.shared
    private let persistence: PersistenceController

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
    }

    func initialize() async {
        do { try await health.requestAuthorization() } catch { print("Health auth error: \(error)") }
        await refreshToday()
        await refreshHistory()
    }

    func refreshToday() async {
        do {
            let today = try await health.fetchToday()
            todaySteps = today.steps
            todayDistanceKm = today.distanceKm
            todayMinutes = today.minutes

            let goal = currentGoal()
            let last7 = await last7StepsArray()
            mlLabelToday = ml.label(todaySteps: todaySteps, dailyGoal: goal, last7Days: last7)

            upsertDailySummary(for: Date(), steps: todaySteps, distanceKm: todayDistanceKm, minutes: todayMinutes, goal: goal, mlLabel: mlLabelToday)
        } catch {
            print("Today fetch error: \(error)")
        }
    }

    func refreshHistory() async {
        do {
            let days = try await health.fetchLastDays(7)
            let ctx = persistence.context
            var summaries: [DailySummary] = []
            for d in days {
                let s = upsertDailySummary(for: d.date, steps: d.steps, distanceKm: d.distanceKm, minutes: d.minutes, goal: currentGoal(), mlLabel: nil)
                summaries.append(s)
            }
            try? ctx.save()
            last7DaysSummaries = summaries.sorted { $0.date < $1.date }
        } catch {
            print("History fetch error: \(error)")
        }
    }

    private func currentGoal() -> Int { Int((fetchProfile()?.dailyStepGoal ?? 8000)) }

    private func fetchProfile() -> UserProfile? {
        let ctx = persistence.context
        let req = NSFetchRequest<UserProfile>(entityName: "UserProfile")
        req.fetchLimit = 1
        return try? ctx.fetch(req).first
    }

    private func last7StepsArray() async -> [Int] {
        let ctx = persistence.context
        let req = NSFetchRequest<DailySummary>(entityName: "DailySummary")
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        req.fetchLimit = 7
        let arr = (try? ctx.fetch(req)) ?? []
        return arr.map { Int($0.totalSteps) }
    }

    @discardableResult
    private func upsertDailySummary(for date: Date, steps: Int, distanceKm: Double, minutes: Int, goal: Int, mlLabel: String?) -> DailySummary {
        let ctx = persistence.context
        let req = NSFetchRequest<DailySummary>(entityName: "DailySummary")
        let dayStart = Calendar.current.startOfDay(for: date)
        req.predicate = NSPredicate(format: "date == %@", dayStart as NSDate)

        let existing = try? ctx.fetch(req).first
        let s: DailySummary
        if let existing = existing {
            s = existing
        } else {
            s = DailySummary(entity: NSEntityDescription.entity(forEntityName: "DailySummary", in: ctx)!, insertInto: ctx)
            s.id = UUID()
        }

        if s.managedObjectContext == nil { ctx.insert(s) }
        s.date = dayStart
        s.totalSteps = Int32(steps)
        s.totalDistanceKm = distanceKm
        s.walkingMinutes = Int32(minutes)
        s.goalReached = computeGoalReached(steps: steps, goal: goal)
        if let label = mlLabel { s.mlLabel = label }
        return s
    }

    // Exposed for unit tests; pure logic
    func computeGoalReached(steps: Int, goal: Int) -> Bool { steps >= goal }
}
