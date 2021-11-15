/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import MultipeerConnectivity.MCPeerID
import XCTest

class AppSelectorsTests: XCTestCase {
    let peerId = MCPeerID(displayName: "Some id")

    func testSelectedPeerId() {
        // Given
        let state = AppState(selectedPeerId: peerId)
        // Then
        XCTAssertEqual(Selectors.getSelectedPeerId.map(state), peerId)
    }

    func testGetPeers() {
        // Given
        let peerId1 = MCPeerID(displayName: "Some peer")
        let peerId2 = MCPeerID(displayName: "Another peer")
        let peerId3 = MCPeerID(displayName: "Third peer")
        let peer1 = Peer(id: peerId1)
        let peer2 = Peer(id: peerId2)
        let peer3 = Peer(id: peerId3)
        let state = [peerId1: peer1, peerId2: peer2, peerId3: peer3]
        // Then
        XCTAssertEqual(Selectors.getPeers.projector(state), [peer2, peer1, peer3])
    }

    func testGetSelectedPeerName() {
        // Given
        let state = AppState(peers: [peerId: Peer(id: peerId)], selectedPeerId: peerId)
        // Then
        XCTAssertEqual(Selectors.getSelectedPeerName.map(state), "Some id")
    }

    func testGetSelectedPeerSnapshots() {
        // Given
        let snapshots = [FluxorExplorerSnapshot(action: TestAction(increment: 1),
                                                oldState: TestState(counter: 0),
                                                newState: TestState(counter: 1))]
        let peer = Peer(id: peerId, snapshots: snapshots)
        // Then
        XCTAssertEqual(Selectors.getSelectedPeerSnapshots.projector(peer), snapshots)
    }
}
