/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

@testable import FluxorExplorer
import MultipeerConnectivity.MCPeerID
import XCTest

class AppSelectorsTests: XCTestCase {
    let peer = MCPeerID(displayName: "Some id")

    func testGetPeersState() {
        // Given
        let state = AppState(peers: PeersState(peers: [peer]))
        // Then
        XCTAssertEqual(Selectors.getPeersState.map(state), state.peers)
    }

    func testGetPeers() {
        // Given
        let peerID1 = MCPeerID(displayName: "Some peer")
        let peerID2 = MCPeerID(displayName: "Another peer")
        let peerID3 = MCPeerID(displayName: "Third peer")
        let state = PeersState(peers: [peerID1, peerID2, peerID3])
        // Then
        XCTAssertEqual(Selectors.getPeers.projector(state), [peerID2, peerID1, peerID3])
    }
}

extension PeersState: Equatable {
    public static func == (lhs: PeersState, rhs: PeersState) -> Bool {
        return lhs.peers == rhs.peers
    }
}
