/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import MultipeerConnectivity
import XCTest

class WindowReducersTests: XCTestCase {
    func testDidReceiveSnapshot() {
        // Given
        let peer = MCPeerID(displayName: "Some id")
        let snapshot = FluxorExplorerSnapshot(action: TestAction(), oldState: TestState(), newState: TestState())
        var state = WindowState(peer: PeerState(peerName: peer.displayName), snapshots: SnapshotsState(snapshots: []))
        // When
        windowReducer.reduce(&state, DidReceiveSnapshotAction(peer: peer, snapshot: snapshot))
        // Then
        XCTAssertEqual(state.snapshots.snapshots.count, 1)
        XCTAssertEqual(state.snapshots.snapshots[0], snapshot)
    }
}

private struct TestState: Encodable {}
private struct TestAction: Action {}
