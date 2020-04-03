/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import MultipeerConnectivity.MCPeerID
import XCTest

class AppEffectsTests: XCTestCase {
    @Published private var action: Action = InitialTestAction()

    func testOpenPeerWindow() {}

    func testRelayReceivedSnapshot() {
        // Given
        let effects = AppEffects($action)
        guard case .nonDispatching = effects.relayReceivedSnapshot else { XCTFail(); return }
        let peer = MCPeerID(displayName: "Some peer")
        let snapshot = FluxorExplorerSnapshot(action: TestAction(), oldState: TestState(counter: 42), newState: TestState(counter: 1337))
        let store = MockStore(initialState: WindowState(peer: PeerState(peerName: peer.displayName)))
        let interceptor = TestInterceptor<WindowState>()
        store.register(interceptor: interceptor)
        Current.storeByPeers[peer.displayName] = store
        // When
        let didReceiveSnapshotAction = DidReceiveSnapshotAction(peer: peer, snapshot: snapshot)
        action = didReceiveSnapshotAction
        // Then
        XCTAssertEqual(interceptor.dispatchedActionsAndStates[0].action as! DidReceiveSnapshotAction, didReceiveSnapshotAction)
    }
}

private struct TestState: Encodable {
    var counter: Int
}

private struct TestAction: Action {}
private struct InitialTestAction: Action {}

extension DidReceiveSnapshotAction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.peer == rhs.peer && lhs.snapshot == rhs.snapshot
    }
}
