/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorTestSupport
import MultipeerConnectivity
import XCTest

// swiftlint:disable force_cast

class PeersViewModelTests: XCTestCase {
    var store: MockStore<AppState, AppEnvironment>!
    var model: PeersViewModel!

    override func setUp() {
        super.setUp()
        store = .init(initialState: AppState(), environment: AppEnvironment())
        model = .init(store: store)
    }

    func testSelectPeer() throws {
        // Given
        let peer = MCPeerID(displayName: "Some peer")
        // When
        model.select(peer: peer)
        // Then
        let action = store.stateChanges[0].action as! SelectPeerAction
        XCTAssertEqual(action.peer, peer)
    }
}
