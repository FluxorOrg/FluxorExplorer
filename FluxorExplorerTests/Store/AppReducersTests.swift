/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

@testable import FluxorExplorer
import FluxorExplorerSnapshot
import MultipeerConnectivity.MCPeerID
import XCTest

class AppReducersTests: XCTestCase {
    let peerId = MCPeerID(displayName: "Some id")
    let snapshot1 = FluxorExplorerSnapshot(action: TestAction(increment: 1),
                                           oldState: TestState(counter: 0),
                                           newState: TestState(counter: 1))
    let snapshot2 = FluxorExplorerSnapshot(action: TestAction(increment: 2),
                                           oldState: TestState(counter: 1),
                                           newState: TestState(counter: 3))

    func testReceivingPeerConnected() {
        // Given
        var state = AppState()
        XCTAssertEqual(state.peers.count, 0)
        // When
        appReducer.reduce(&state, Actions.peerConnected(payload: peerId))
        // Then
        XCTAssertEqual(state.peers.count, 1)
        XCTAssertTrue(state.peers.contains(where: { $0.key == peerId }))
    }

    func testReceivingPeerDisconnected() {
        // Given
        var state = AppState(peers: [peerId: Peer(id: peerId)])
        // When
        appReducer.reduce(&state, Actions.peerDisconnected(payload: peerId))
        // Then
        XCTAssertEqual(state.peers.count, 0)
    }

    func testReceivingSelectPeer() {
        // Given
        var state = AppState()
        // When
        appReducer.reduce(&state, Actions.selectPeer(payload: peerId))
        // Then
        XCTAssertEqual(state.selectedPeerId, peerId)
    }

    func testReceivingDeselectPeer() {
        // Given
        var state = AppState(selectedPeerId: peerId)
        // When
        appReducer.reduce(&state, Actions.deselectPeer(payload: peerId))
        // Then
        XCTAssertNil(state.selectedPeerId)
    }

    func testReceivingDidReceiveSnapshot() {
        // Given
        var state = AppState(peers: [peerId: Peer(id: peerId, snapshots: [snapshot1])])
        // When
        appReducer.reduce(&state, Actions.didReceiveSnapshot(payload:
            (peerId: peerId, snapshot: snapshot2)))
        // Then
        XCTAssertEqual(state.peers[peerId]?.snapshots, [snapshot1, snapshot2])
    }

    func testReceivingSelectSnapshot() {
        // Given
        var state = AppState(peers: [peerId: Peer(id: peerId, snapshots: [snapshot1])])
        // When
        appReducer.reduce(&state, Actions.selectSnapshot(payload: (peerId: peerId, snapshot: snapshot1)))
        // Then
        XCTAssertEqual(state.peers[peerId]?.selectedSnaphot, snapshot1)
    }

    func testReceivingDeselectSnapshot() {
        // Given
        var state = AppState(peers: [
            peerId: Peer(id: peerId, snapshots: [snapshot1, snapshot2], selectedSnaphot: snapshot1)
        ])
        // When
        appReducer.reduce(&state, Actions.deselectSnapshot(payload: (peerId: peerId, snapshot: snapshot2)))
        // Then
        XCTAssertEqual(state.peers[peerId]?.selectedSnaphot, snapshot1)
        // When
        appReducer.reduce(&state, Actions.deselectSnapshot(payload: (peerId: peerId, snapshot: snapshot1)))
        // Then
        XCTAssertNil(state.peers[peerId]?.selectedSnaphot)
    }
}
