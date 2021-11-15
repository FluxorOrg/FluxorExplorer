/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorTestSupport
import MultipeerConnectivity
import ViewInspector
import XCTest

class PeersViewTests: ViewTestCase {
    private let peerId1 = MCPeerID(displayName: "Peer 1")
    private let peerId2 = MCPeerID(displayName: "Peer 2")
    private lazy var peers = [Peer(id: peerId1), Peer(id: peerId2)]

    func testNoPeers() throws {
        // Given
        let view = PeersView(store: mockStore)
        // Then
        let vStack = try view.inspect().hStack().vStack(0)
        let headline = try vStack.text(0).string()
        let body = try vStack.text(1).string()
        XCTAssertEqual(headline, "No devices connected")
        XCTAssertEqual(body, "Make sure the application is launched and the Interceptor is registered.")
    }

    func testPeers() throws {
        // Given
        mockStore.overrideSelector(Selectors.getPeers, value: peers)
        let view = PeersView(store: mockStore)
        // Then
        let listElements = try view.inspect().hStack().list(0).forEach(0)
        XCTAssertEqual(listElements.count, peers.count)
        try peers.indices.forEach {
            XCTAssertEqual(try listElements.navigationLink($0).labelView().text().string(), peers[$0].name)
        }
    }

    func testPeerSelection() throws {
        // Given
        let peerId = MCPeerID(displayName: "Some id")
        mockStore.overrideSelector(Selectors.getPeers, value: peers)
        let view = PeersView(store: mockStore)
        // When
        let listElements = try view.inspect().hStack().list(0).forEach(0)
        try listElements.navigationLink(0).activate()
        // Then
        XCTAssertEqual(mockStore.dispatchedActions[0] as! AnonymousAction<MCPeerID>,
                       Actions.selectPeer(payload: peerId))
        // When
        try listElements.navigationLink(0).deactivate()
        // Then
        XCTAssertEqual(mockStore.dispatchedActions[1] as! AnonymousAction<MCPeerID>,
                       Actions.deselectPeer(payload: peerId))
    }
}

extension PeersView: Inspectable {}
