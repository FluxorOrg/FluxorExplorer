/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import XCTest

class WindowSelectorsTests: XCTestCase {
    let snapshots = [FluxorExplorerSnapshot(action: TestAction(), oldState: TestState(), newState: TestState())]

    func testGetSnapshotsState() {
        // Given
        let state = WindowState(peer: PeerState(peerName: "Some peer"), snapshots: SnapshotsState(snapshots: snapshots))
        // Then
        XCTAssertEqual(Selectors.getSnapshotsState.map(state), state.snapshots)
    }

    func testGetSnapshots() {
        // Given
        let state = WindowState(peer: PeerState(peerName: "Some peer"), snapshots: SnapshotsState(snapshots: snapshots))
        // Then
        XCTAssertEqual(Selectors.getSnapshots.map(state), snapshots)
    }
}

extension SnapshotsState: Equatable {
    public static func == (lhs: SnapshotsState, rhs: SnapshotsState) -> Bool {
        return lhs.snapshots == rhs.snapshots
    }
}

private struct TestState: Encodable {}
private struct TestAction: Action {}
