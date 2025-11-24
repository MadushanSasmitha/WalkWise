import XCTest
@testable import WalkWise

final class HealthViewModelTests: XCTestCase {
    func testGoalReachedLogic() {
        let vm = HealthViewModel(persistence: PersistenceController(inMemory: true))
        XCTAssertTrue(vm.computeGoalReached(steps: 8000, goal: 8000))
        XCTAssertTrue(vm.computeGoalReached(steps: 10000, goal: 8000))
        XCTAssertFalse(vm.computeGoalReached(steps: 5000, goal: 8000))
    }
}
