/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import FluxorTestSupport
import MultipeerConnectivity.MCPeerID
import XCTest

// swiftlint:disable force_cast

class AppEffectsTests: XCTestCase {
    func testOpenPeerWindow() throws {
        // Given
        let effects = AppEffects()
        let peer = MCPeerID(displayName: "Some peer")
        let mockApplication = MockApplication()
        let environment = AppEnvironment()
        environment.application = mockApplication
        // When
        try EffectRunner.run(effects.openPeerWindow, with: SelectPeerAction(peer: peer), environment: environment)
        // Then
        let selectedDisplayName = mockApplication.userActivityForRequestedSceneSession!.userInfo!["peerName"] as! String
        XCTAssertEqual(selectedDisplayName, peer.displayName)
    }

    func testRelayReceivedSnapshot() throws {
        // Given
        let effects = AppEffects()
        let peer = MCPeerID(displayName: "Some peer")
        let environment = AppEnvironment()
        let snapshot = FluxorExplorerSnapshot(action: TestAction(),
                                              oldState: TestState(counter: 42),
                                              newState: TestState(counter: 1337))
        let store = MockStore(initialState: WindowState(peer: PeerState(peerName: peer.displayName)),
                              environment: environment)
        FluxorExplorerApp.storeByPeers[peer.displayName] = store
        // When
        let didReceiveSnapshotAction = DidReceiveSnapshotAction(peer: peer, snapshot: snapshot)
        try EffectRunner.run(effects.relayReceivedSnapshot, with: didReceiveSnapshotAction, environment: environment)
        // Then
        let dispatchedAction = store.stateChanges[0].action as! DidReceiveSnapshotAction
        XCTAssertEqual(dispatchedAction, didReceiveSnapshotAction)
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

private class MockApplication: UIApplicationProtocol {
    var userActivityForRequestedSceneSession: NSUserActivity?

    func requestSceneSessionActivation(_ sceneSession: UISceneSession?,
                                       userActivity: NSUserActivity?,
                                       options: UIScene.ActivationRequestOptions?,
                                       errorHandler: ((Error) -> Void)?) {
        userActivityForRequestedSceneSession = userActivity
    }
}
