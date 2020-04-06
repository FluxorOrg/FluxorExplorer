/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import MultipeerConnectivity
import XCTest

class SessionHandlerTests: XCTestCase {
    let peer = MCPeerID(displayName: "Some peer")
    let serviceType = "fluxor-explorer"

    func testSessionConnected() {
        // Given
        let handler = SessionHandler()
        let session = MCSession(peer: peer)
        let store = Store(initialState: AppState())
        let interceptor = TestInterceptor<AppState>()
        store.register(interceptor: interceptor)
        Current.store = store
        // When
        handler.session(session, peer: peer, didChange: .connected)
        // Then
        waitFor {
            let action = interceptor.dispatchedActionsAndStates[0].action as! PeerConnectedAction
            XCTAssertEqual(action.peer, self.peer)
        }
    }

    func testSessionNotConnected() {
        // Given
        let handler = SessionHandler()
        let session = MCSession(peer: peer)
        let store = Store(initialState: AppState())
        let interceptor = TestInterceptor<AppState>()
        store.register(interceptor: interceptor)
        Current.store = store
        // When
        handler.session(session, peer: peer, didChange: .notConnected)
        // Then
        waitFor {
            let action = interceptor.dispatchedActionsAndStates[0].action as! PeerDisconnectedAction
            XCTAssertEqual(action.peer, self.peer)
        }
    }

    func testSessionDidReceiveData() throws {
        // Given
        let handler = SessionHandler()
        let session = MCSession(peer: peer)
        let store = Store(initialState: AppState())
        let interceptor = TestInterceptor<AppState>()
        store.register(interceptor: interceptor)
        Current.store = store
        // When
        let snapshot = FluxorExplorerSnapshot(action: TestAction(increment: 1),
                                              oldState: TestState(counter: 42),
                                              newState: TestState(counter: 1337))
        let data = try JSONEncoder().encode(snapshot)
        handler.session(session, didReceive: data, fromPeer: peer)
        // Then
        waitFor {
            let action = interceptor.dispatchedActionsAndStates[0].action as! DidReceiveSnapshotAction
            XCTAssertEqual(action.peer, self.peer)
            XCTAssertEqual(action.snapshot, snapshot)
        }
    }

    func testBrowserFoundPeer() {
        // Given
        let handler = SessionHandler()
        let browser = MockBrowser(peer: peer, serviceType: serviceType)
        let otherPeer = MCPeerID(displayName: "Another peer")
        // When
        handler.browser(browser, foundPeer: otherPeer, withDiscoveryInfo: nil)
        // Then
        XCTAssertEqual(browser.invitedPeer, otherPeer)
    }

    func testNoExplosion() {
        // Given
        let session = MCSession(peer: peer)
        let browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        let handler = SessionHandler()
        // When
        handler.session(session, peer: peer, didChange: .connecting)
        handler.session(session, didReceive: Data(), fromPeer: peer)
        handler.session(session, didReceive: InputStream(), withName: "", fromPeer: peer)
        handler.session(session, didStartReceivingResourceWithName: "", fromPeer: peer, with: Progress())
        handler.session(session, didFinishReceivingResourceWithName: "", fromPeer: peer, at: nil, withError: nil)
        handler.browser(browser, lostPeer: peer)
        handler.browser(browser, didNotStartBrowsingForPeers: MCError(.notConnected))
        // Then
        // Nothing explodes (and coverage isn't harmed)
    }
}

private class MockBrowser: MCNearbyServiceBrowser {
    var invitedPeer: MCPeerID?

    override func invitePeer(_ peerID: MCPeerID, to session: MCSession, withContext context: Data?, timeout: TimeInterval) {
        invitedPeer = peerID
    }
}

private struct TestState: Encodable {
    let counter: Int
}

private struct TestAction: Action {
    let increment: Int
}
