import Foundation
import HealthKit

// HealthManager centralizes HealthKit authorization and queries for steps, distance, and walking minutes.
// For Simulator, HealthKit is unavailable; this returns stubbed data.
final class HealthManager {
    static let shared = HealthManager()
    private let healthStore = HKHealthStore()

    private var isAuthorized = false

    private init() {}

    // Request read authorization for step count, walking/running distance, and exercise minutes
    func requestAuthorization() async throws {
#if targetEnvironment(simulator)
        // Never attempt to authorize on Simulator to avoid Obj-C exceptions
        isAuthorized = false
        return
#endif
        guard HKHealthStore.isHealthDataAvailable() else { return }

        // Ensure Info.plist contains NSHealthShareUsageDescription; if missing, skip to avoid exception
        let hasUsageKey = Bundle.main.object(forInfoDictionaryKey: "NSHealthShareUsageDescription") as? String
        guard hasUsageKey != nil else { return }

        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]

        try await healthStore.requestAuthorization(toShare: [], read: readTypes)
        isAuthorized = true
    }

    // Fetch today's aggregates for steps, distance (km), and exercise minutes
    func fetchToday() async throws -> (steps: Int, distanceKm: Double, minutes: Int) {
        guard HKHealthStore.isHealthDataAvailable(), isAuthorized else {
            // Simulator stub
            return (steps: Int.random(in: 2500...9500), distanceKm: Double.random(in: 1.2...6.8), minutes: Int.random(in: 10...60))
        }
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let now = Date()

        async let steps: Int = sumQuantity(.stepCount, unit: HKUnit.count(), start: startOfDay, end: now).map(Int.init) ?? 0
        async let distance: Double = sumQuantity(.distanceWalkingRunning, unit: HKUnit.meter(), start: startOfDay, end: now).map { $0 / 1000.0 } ?? 0.0
        async let minutes: Int = sumQuantity(.appleExerciseTime, unit: HKUnit.minute(), start: startOfDay, end: now).map(Int.init) ?? 0

        return try await (steps: steps, distanceKm: distance, minutes: minutes)
    }

    // Fetch last N days (including today) summaries
    func fetchLastDays(_ days: Int) async throws -> [(date: Date, steps: Int, distanceKm: Double, minutes: Int)] {
        guard HKHealthStore.isHealthDataAvailable(), isAuthorized else {
            // Stub sequence for Simulator
            let today = Calendar.current.startOfDay(for: Date())
            return (0..<days).map { i in
                let date = Calendar.current.date(byAdding: .day, value: -i, to: today)!
                return (date, Int.random(in: 2000...12000), Double.random(in: 1.0...9.0), Int.random(in: 10...90))
            }.reversed()
        }

        var results: [(Date, Int, Double, Int)] = []
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        for i in 0..<days {
            let start = calendar.date(byAdding: .day, value: -i, to: today)!
            let dayStart = calendar.startOfDay(for: start)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!

            let steps = (try await sumQuantity(.stepCount, unit: .count(), start: dayStart, end: dayEnd)).map(Int.init) ?? 0
            let distanceKm = (try await sumQuantity(.distanceWalkingRunning, unit: .meter(), start: dayStart, end: dayEnd)).map { $0 / 1000.0 } ?? 0.0
            let minutes = (try await sumQuantity(.appleExerciseTime, unit: .minute(), start: dayStart, end: dayEnd)).map(Int.init) ?? 0

            results.append((dayStart, steps, distanceKm, minutes))
        }
        return results.sorted { $0.0 < $1.0 }
    }

    // MARK: - Helpers
    private func sumQuantity(_ id: HKQuantityTypeIdentifier, unit: HKUnit, start: Date, end: Date) async throws -> Double? {
        guard let type = HKObjectType.quantityType(forIdentifier: id) else { return nil }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, stats, error in
                if let error = error { continuation.resume(throwing: error); return }
                let value = stats?.sumQuantity()?.doubleValue(for: unit)
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }
}
