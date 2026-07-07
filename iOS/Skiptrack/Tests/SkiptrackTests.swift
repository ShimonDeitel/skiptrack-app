import XCTest
@testable import Skiptrack

@MainActor
final class SkiptrackTests: XCTestCase {

    func makeStore() -> Store {
        let store = Store()
        store.items = []
        store.save()
        return store
    }

    func testInitialSeedBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = makeStore()
        let before = store.items.count
        store.add(Class(name: "Test", allowedAbsences: 1, absencesUsed: 1))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = makeStore()
        let item = Class(name: "Test", allowedAbsences: 1, absencesUsed: 1)
        store.add(item)
        XCTAssertTrue(store.items.contains(item))
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = makeStore()
        store.isPro = false
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        let store = makeStore()
        store.isPro = false
        for i in 0..<Store.freeLimit {
            store.add(Class(name: "Item \(i)", allowedAbsences: i, absencesUsed: i))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testProUsersCanAlwaysAdd() {
        let store = makeStore()
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(Class(name: "Item \(i)", allowedAbsences: i, absencesUsed: i))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testPersistenceRoundTrip() {
        let store = makeStore()
        let item = Class(name: "Test", allowedAbsences: 1, absencesUsed: 1)
        store.add(item)
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.id == item.id }))
    }
}
