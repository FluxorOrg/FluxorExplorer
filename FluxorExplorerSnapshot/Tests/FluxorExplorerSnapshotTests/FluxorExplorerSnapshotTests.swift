/**
 * FluxorExplorerSnapshotTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import AnyCodable
import Fluxor
@testable import FluxorExplorerSnapshot
import XCTest

class FluxorExplorerSnapshotTests: XCTestCase {
    private let action = TestAction(increment: 1)
    private let otherAction = OtherTestAction()
    let oldState = State(count: 1)
    let otherOldState = State(count: 2)
    let newState = State(count: 3)
    let otherNewState = State(count: 4)
    let date = Date(timeIntervalSince1970: 1576706397)
    // swiftlint:disable:next line_length
    let json = #"{"action":{"name":"TestAction","payload":{"increment":1}},"newState":{"count":3},"oldState":{"count":1},"date":598399197}"#

    func testEqual() throws {
        let snapshot1 = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
        let snapshot2 = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
        XCTAssertTrue(snapshot1 == snapshot2)
    }

    func testNotEqualByAction() throws {
        let snapshot1 = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
        let snapshot2 = FluxorExplorerSnapshot(action: otherAction, oldState: oldState, newState: newState, date: date)
        XCTAssertFalse(snapshot1 == snapshot2)
    }

    func testNotEqualByOldState() throws {
        let snapshot1 = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
        let snapshot2 = FluxorExplorerSnapshot(action: action, oldState: otherOldState, newState: newState, date: date)
        XCTAssertFalse(snapshot1 == snapshot2)
    }

    func testNotEqualByNewState() throws {
        let snapshot1 = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
        let snapshot2 = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: otherNewState, date: date)
        XCTAssertFalse(snapshot1 == snapshot2)
    }

    func testInitWithStateAndActionWithPayload() throws {
        let snapshot = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
        XCTAssertEqual(snapshot.actionData.name, "TestAction")
        XCTAssertEqual(snapshot.actionData.payload, ["increment": AnyCodable(action.increment)])
        XCTAssertEqual(snapshot.oldState, ["count": AnyCodable(oldState.count)])
        XCTAssertEqual(snapshot.newState, ["count": AnyCodable(newState.count)])
    }

    func testInitWithStateAndActionWithoutPayload() throws {
        let snapshot = FluxorExplorerSnapshot(action: otherAction, oldState: oldState, newState: newState, date: date)
        XCTAssertEqual(snapshot.actionData.name, "OtherTestAction")
        XCTAssertEqual(snapshot.actionData.payload, ["error": "Action is not encodable and couldn't be encoded."])
        XCTAssertEqual(snapshot.oldState, ["count": AnyCodable(oldState.count)])
        XCTAssertEqual(snapshot.newState, ["count": AnyCodable(newState.count)])
    }

    func testEncode() throws {
        let snapshot = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
        let data = try JSONEncoder().encode(snapshot)
        XCTAssertEqual(String(data: data, encoding: .utf8), json)
    }

    func testDecode() throws {
        let snapshot = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
        let data = json.data(using: .utf8)!
        let decodedSnapshot = try JSONDecoder().decode(FluxorExplorerSnapshot.self, from: data)
        XCTAssertEqual(snapshot, decodedSnapshot)
    }

    func testPublicInit() {
        let snapshot = FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState)
        XCTAssertLessThan(snapshot.date, Date())
    }
}

private struct TestAction: EncodableAction {
    let increment: Int
}

private struct OtherTestAction: Action {}

struct State: Encodable {
    var count = 42
}
