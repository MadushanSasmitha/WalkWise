import XCTest
@testable import WalkWise

final class SessionViewModelTests: XCTestCase {
    func testCRUD() throws {
        let persistence = PersistenceController(inMemory: true)
        let vm = SessionViewModel(persistence: persistence)

        // Initially empty
        vm.loadSessions()
        XCTAssertEqual(vm.sessions.count, 0)

        // Create
        vm.addSession(name: "Morning Walk", targetMinutes: 30, targetDistanceKm: 2.5, scheduledTime: nil)
        vm.loadSessions()
        XCTAssertEqual(vm.sessions.count, 1)
        let s = try XCTUnwrap(vm.sessions.first)
        XCTAssertEqual(s.name, "Morning Walk")

        // Update
        vm.updateSession(session: s, name: "Evening Walk", targetMinutes: 45, targetDistanceKm: 3.2, scheduledTime: Date())
        vm.loadSessions()
        let updated = try XCTUnwrap(vm.sessions.first)
        XCTAssertEqual(updated.name, "Evening Walk")
        XCTAssertEqual(updated.targetMinutes, 45)

        // Delete
        vm.deleteSession(at: IndexSet(integer: 0))
        XCTAssertEqual(vm.sessions.count, 0)
    }
}
