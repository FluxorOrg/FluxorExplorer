/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import MultipeerConnectivity
import SwiftUI
import ViewInspector
import XCTest

class SnapshotsViewTests: ViewTestCase {
    let snapshots = [FluxorExplorerSnapshot(action: TestAction(increment: 1),
                                            oldState: TestState(counter: 1),
                                            newState: TestState(counter: 2)),
                     FluxorExplorerSnapshot(action: TestAction(increment: 40),
                                            oldState: TestState(counter: 2),
                                            newState: TestState(counter: 42))]

    func testNoSnapshots() throws {
        // Given
        let view = SnapshotsView(store: mockStore)
        // Then
        let vStack = try getHStack(in: view).vStack(0)
        let headline = try vStack.text(0).string()
        XCTAssertEqual(headline, "No snapshots yet")
    }

    func testSnapshots() throws {
        // Given
        mockStore.overrideSelector(Selectors.getSelectedPeerSnapshots, value: snapshots)
        let view = SnapshotsView(store: mockStore)
        // Then
        let listElements = try getListElements(in: view)
        XCTAssertEqual(listElements.count, snapshots.count)
        try snapshots.indices.forEach {
            let navigationLink = try listElements.navigationLink($0)
            XCTAssertFalse(try navigationLink.isActive())
            XCTAssertEqual(try navigationLink.view(SnapshotView.self).actualView().snapshot, snapshots[$0])
            XCTAssertEqual(try navigationLink.labelView().vStack().text(0).string(),
                           snapshots[$0].actionData.name)
        }
    }

    func testTimeBackgroundColor() throws {
        // Given
        mockStore.overrideSelector(Selectors.getSelectedPeerSnapshots, value: snapshots)
        let view = SnapshotsView(store: mockStore)
        // Then
        XCTAssertEqual(view.timeBackgroundColor(for: .dark), Color(.darkGray))
        XCTAssertEqual(view.timeBackgroundColor(for: .light), Color(.init(white: 0.9, alpha: 1)))
    }

    func testSnapshotSelection() throws {
        // Given
        let peerId = MCPeerID(displayName: "some id")
        mockStore.overrideSelector(Selectors.getSelectedPeerId, value: peerId)
        mockStore.overrideSelector(Selectors.getSelectedPeerSnapshots, value: snapshots)
        let view = SnapshotsView(store: mockStore)
        // When
        let listElements = try getListElements(in: view)
        try listElements.navigationLink(0).activate()
        // Then
        let dispatchedSelectAction = mockStore.dispatchedActions[0] as! AnonymousAction<(peerId: MCPeerID?, snapshot: FluxorExplorerSnapshot)>
        let selectAction = Actions.selectSnapshot(payload: (peerId: peerId, snapshot: snapshots[0]))
        XCTAssertEqual(dispatchedSelectAction, selectAction)
        // When
        try listElements.navigationLink(0).deactivate()
        // Then
        let dispatchedDeselectAction = mockStore.dispatchedActions[1] as! AnonymousAction<(peerId: MCPeerID?, snapshot: FluxorExplorerSnapshot)>
        let deselectAction = Actions.deselectSnapshot(payload: (peerId: peerId, snapshot: snapshots[0]))
        XCTAssertEqual(dispatchedDeselectAction, deselectAction)
    }

    private func getHStack(in view: SnapshotsView) throws -> InspectableView<ViewType.HStack> {
        try view.inspect().hStack()
    }

    private func getListElements(in view: SnapshotsView) throws -> InspectableView<ViewType.ForEach> {
        try getHStack(in: view).list(0).forEach(0)
    }
}

extension SnapshotsView: Inspectable {}
