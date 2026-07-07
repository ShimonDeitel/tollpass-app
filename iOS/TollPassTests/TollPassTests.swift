import XCTest
@testable import TollPass

final class TollPassTests: XCTestCase {
    var store: TollPassStore!

    override func setUp() {
        super.setUp()
        store = TollPassStore()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.transponders.count, TollPassStore.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.transponders.count
        let added = store.add(Transponder(name: "T", region: "R", balance: 10), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.transponders.count, before + 1)
    }

    func testAddRespectsFreeLimitWhenNotPro() {
        while store.transponders.count < TollPassStore.freeTierLimit {
            _ = store.add(Transponder(name: "T", region: "R", balance: 10), isPro: false)
        }
        let blocked = store.add(Transponder(name: "T", region: "R", balance: 10), isPro: false)
        XCTAssertFalse(blocked)
    }

    func testProBypassesFreeLimit() {
        while store.transponders.count < TollPassStore.freeTierLimit {
            _ = store.add(Transponder(name: "T", region: "R", balance: 10), isPro: false)
        }
        let allowed = store.add(Transponder(name: "T", region: "R", balance: 10), isPro: true)
        XCTAssertTrue(allowed)
    }

    func testCanAddReflectsLimit() {
        while store.transponders.count < TollPassStore.freeTierLimit {
            _ = store.add(Transponder(name: "T", region: "R", balance: 10), isPro: false)
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testRemoveDecreasesCount() {
        _ = store.add(Transponder(name: "T", region: "R", balance: 10), isPro: false)
        let before = store.transponders.count
        store.remove(at: IndexSet(integer: 0))
        XCTAssertEqual(store.transponders.count, before - 1)
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testPersistedStateRoundTrips() {
        let count = store.transponders.count
        let reloaded = TollPassStore()
        XCTAssertEqual(reloaded.transponders.count, count)
    }
}
