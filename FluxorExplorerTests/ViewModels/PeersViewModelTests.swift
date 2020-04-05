/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import MultipeerConnectivity
import XCTest

class PeersViewModelTests: XCTestCase {
    var store: Store<AppState>!
    var interceptor: TestInterceptor<AppState>!
    var model: PeersViewModel!

    override func setUp() {
        super.setUp()
        interceptor = .init()
        store = .init(initialState: AppState())
        store.register(interceptor: interceptor)
        model = .init(store: store)
    }

    func testSelectPeer() throws {
        // Given
        let peer = MCPeerID(displayName: "Some peer")
        // When
        model.select(peer: peer)
        // Then
        let action = interceptor.dispatchedActionsAndStates[0].action as! SelectPeerAction
        XCTAssertEqual(action.peer, peer)
    }
}
