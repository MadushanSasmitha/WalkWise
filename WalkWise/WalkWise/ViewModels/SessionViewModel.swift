import Foundation
import SwiftUI
import CoreData
import Combine

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var sessions: [WalkSession] = []
    @Published var showAddEditSheet: Bool = false
    @Published var selectedSession: WalkSession?

    private let persistence: PersistenceController

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
    }

    func loadSessions() {
        let ctx = persistence.context
        let req = NSFetchRequest<WalkSession>(entityName: "WalkSession")
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        sessions = (try? ctx.fetch(req)) ?? []
    }

    func addSession(name: String, targetMinutes: Int, targetDistanceKm: Double, scheduledTime: Date?) {
        let ctx = persistence.context
        let s = WalkSession(entity: NSEntityDescription.entity(forEntityName: "WalkSession", in: ctx)!, insertInto: ctx)
        s.id = UUID()
        s.name = name
        s.targetMinutes = Int32(targetMinutes)
        s.targetDistanceKm = targetDistanceKm
        s.scheduledTime = scheduledTime
        s.createdAt = Date()
        persistence.save()
        loadSessions()
    }

    func updateSession(session: WalkSession, name: String, targetMinutes: Int, targetDistanceKm: Double, scheduledTime: Date?) {
        session.name = name
        session.targetMinutes = Int32(targetMinutes)
        session.targetDistanceKm = targetDistanceKm
        session.scheduledTime = scheduledTime
        persistence.save()
        loadSessions()
    }

    func deleteSession(at offsets: IndexSet) {
        let ctx = persistence.context
        offsets.map { sessions[$0] }.forEach { ctx.delete($0) }
        persistence.save()
        loadSessions()
    }
}
