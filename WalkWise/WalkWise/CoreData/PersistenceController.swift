import Foundation
import CoreData

// PersistenceController builds a programmatic Core Data stack using an in-memory model definition.
// This avoids needing an .xcdatamodeld file and works on Simulator and device.
// Entities: UserProfile, WalkSession, DailySummary
final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    // Convenience context for SwiftUI environment
    var context: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool = false) {
        // Build the model programmatically so the project stays self-contained
        let model = Self.makeModel()
        container = NSPersistentContainer(name: "WalkWiseModel", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved Core Data error: \(error)")
            }
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    // MARK: - Programmatic Model
    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // UserProfile
        let userProfile = NSEntityDescription()
        userProfile.name = "UserProfile"
        userProfile.managedObjectClassName = NSStringFromClass(UserProfile.self)
        userProfile.properties = [
            makeAttribute("id", .UUIDAttributeType, isOptional: false),
            makeAttribute("displayName", .stringAttributeType),
            makeAttribute("email", .stringAttributeType),
            makeAttribute("dailyStepGoal", .integer32AttributeType),
            makeAttribute("units", .stringAttributeType),
            makeAttribute("profileImageData", .binaryDataAttributeType, isOptional: true),
            makeAttribute("createdAt", .dateAttributeType)
        ]

        // WalkSession
        let walkSession = NSEntityDescription()
        walkSession.name = "WalkSession"
        walkSession.managedObjectClassName = NSStringFromClass(WalkSession.self)
        walkSession.properties = [
            makeAttribute("id", .UUIDAttributeType, isOptional: false),
            makeAttribute("name", .stringAttributeType),
            makeAttribute("targetMinutes", .integer32AttributeType),
            makeAttribute("targetDistanceKm", .doubleAttributeType),
            makeAttribute("scheduledTime", .dateAttributeType, isOptional: true),
            makeAttribute("createdAt", .dateAttributeType)
        ]

        // DailySummary
        let dailySummary = NSEntityDescription()
        dailySummary.name = "DailySummary"
        dailySummary.managedObjectClassName = NSStringFromClass(DailySummary.self)
        dailySummary.properties = [
            makeAttribute("id", .UUIDAttributeType, isOptional: false),
            makeAttribute("date", .dateAttributeType),
            makeAttribute("totalSteps", .integer32AttributeType),
            makeAttribute("totalDistanceKm", .doubleAttributeType),
            makeAttribute("walkingMinutes", .integer32AttributeType),
            makeAttribute("goalReached", .booleanAttributeType),
            makeAttribute("mlLabel", .stringAttributeType, isOptional: true)
        ]

        model.entities = [userProfile, walkSession, dailySummary]
        return model
    }

    private static func makeAttribute(_ name: String, _ type: NSAttributeType, isOptional: Bool = false) -> NSAttributeDescription {
        let a = NSAttributeDescription()
        a.name = name
        a.attributeType = type
        a.isOptional = isOptional
        return a
    }

    // MARK: - Helpers
    func save() {
        let ctx = container.viewContext
        if ctx.hasChanges {
            do { try ctx.save() } catch { print("Core Data save error: \(error)") }
        }
    }
}

// MARK: - NSManagedObject subclasses
@objc(UserProfile)
public class UserProfile: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var displayName: String
    @NSManaged public var email: String
    @NSManaged public var dailyStepGoal: Int32
    @NSManaged public var units: String
    @NSManaged public var profileImageData: Data?
    @NSManaged public var createdAt: Date
}

@objc(WalkSession)
public class WalkSession: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var targetMinutes: Int32
    @NSManaged public var targetDistanceKm: Double
    @NSManaged public var scheduledTime: Date?
    @NSManaged public var createdAt: Date
}

@objc(DailySummary)
public class DailySummary: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var totalSteps: Int32
    @NSManaged public var totalDistanceKm: Double
    @NSManaged public var walkingMinutes: Int32
    @NSManaged public var goalReached: Bool
    @NSManaged public var mlLabel: String?
}
