/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import MultipeerConnectivity
import ViewInspector
import XCTest

class PeersViewTests: XCTestCase {
    let peers = [MCPeerID(displayName: "Peer 1"), MCPeerID(displayName: "Peer 2")]

    func testNoPeers() throws {
        // Given
        let view = PeersView()
        // Then
        let vStack = try getHStack(in: view).vStack(0)
        let headline = try vStack.text(0).string()
        let body = try vStack.text(1).string()
        XCTAssertEqual(headline, "No devices connected")
        XCTAssertEqual(body, "Make sure the application is launched and the Interceptor is registered.")
    }

    func testPeers() throws {
        // Given
        let view = PeersView(peers: peers)
        // Then
        let listElements = try getListElements(in: view)
        XCTAssertEqual(listElements.count, peers.count)
        try peers.indices.forEach {
            XCTAssertEqual(try listElements.button($0).labelView().text().string(), peers[$0].displayName)
        }
    }

    func testSelectPeer() throws {
        // Given
        let viewModel = MockViewModel()
        let view = PeersView(model: viewModel, peers: peers)
        // When
        let listElements = try getListElements(in: view)
        try listElements.button(0).tap()
        // Then
        XCTAssertEqual(viewModel.selectedPeer, peers[0])
    }

    private func getHStack(in view: PeersView) throws -> InspectableView<ViewType.HStack> {
        return try view.inspect().navigationView().hStack(0)
    }

    private func getListElements(in view: PeersView) throws -> InspectableView<ViewType.ForEach> {
        return try getHStack(in: view).list(0).forEach(0)
    }
}

private class MockViewModel: PeersViewModel {
    var selectedPeer: MCPeerID?

    override func select(peer: MCPeerID) {
        selectedPeer = peer
    }
}

extension PeersView: Inspectable {}
