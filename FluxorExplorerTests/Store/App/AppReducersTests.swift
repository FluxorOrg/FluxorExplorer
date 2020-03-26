/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

@testable import FluxorExplorer
import MultipeerConnectivity.MCPeerID
import XCTest

class AppReducersTests: XCTestCase {
    let peer = MCPeerID(displayName: "Some id")
    
    func testReceivingPeerConnected() {
        // Given
        var state = AppState()
        XCTAssertEqual(state.peers.peers.count, 0)
        // When
        appReducer.reduce(&state, PeerConnectedAction(peer: peer))
        // Then
        XCTAssertEqual(state.peers.peers.count, 1)
        XCTAssertEqual(state.peers.peers[0], peer)
    }
    
    func testReceivingPeerDisconnected() {
        // Given
        var state = AppState(peers: PeersState(peers: [peer]))
        // When
        appReducer.reduce(&state, PeerDisconnectedAction(peer: peer))
        // Then
        XCTAssertEqual(state.peers.peers.count, 0)
    }
}
