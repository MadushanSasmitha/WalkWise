import Foundation
import SwiftUI
import Combine
import CoreData

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?

    private let persistence = PersistenceController.shared

    func loadOrCreateProfile(defaultEmail: String?) {
        let ctx = persistence.context
        let req = NSFetchRequest<UserProfile>(entityName: "UserProfile")
        req.fetchLimit = 1
        if let p = try? ctx.fetch(req).first {
            profile = p
            return
        }
        let p = UserProfile(entity: NSEntityDescription.entity(forEntityName: "UserProfile", in: ctx)!, insertInto: ctx)
        p.id = UUID()
        p.displayName = "Walker"
        p.email = defaultEmail ?? ""
        p.dailyStepGoal = 8000
        p.units = "km"
        p.createdAt = Date()
        profile = p
        persistence.save()
    }

    func updateName(_ name: String) {
        profile?.displayName = name
        persistence.save()
    }

    func updateGoal(_ goal: Int) {
        profile?.dailyStepGoal = Int32(goal)
        persistence.save()
    }

    func updateUnits(_ units: String) {
        profile?.units = units
        persistence.save()
    }

    func updateImage(_ data: Data?) {
        profile?.profileImageData = data
        persistence.save()
    }
}
