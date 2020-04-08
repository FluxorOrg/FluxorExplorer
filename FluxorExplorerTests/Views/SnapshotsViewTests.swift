/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import SwiftUI
import ViewInspector
import XCTest

class SnapshotsViewTests: XCTestCase {
    let store = Store(initialState: WindowState(peer: PeerState(peerName: "Some peer")))
    let snapshots = [FluxorExplorerSnapshot(action: TestAction(),
                                            oldState: TestState(counter: 1),
                                            newState: TestState(counter: 2)),
                     FluxorExplorerSnapshot(action: OtherTestAction(),
                                            oldState: TestState(counter: 2),
                                            newState: TestState(counter: 42))]

    func testNoSnapshots() throws {
        // Given
        let view = SnapshotsView(model: SnapshotsViewModel(store: store))
        // Then
        let vStack = try getHStack(in: view).vStack(0)
        let headline = try vStack.text(0).string()
        XCTAssertEqual(headline, "No snapshots yet")
    }

    func testSnapshots() throws {
        // Given
        let view = SnapshotsView(model: SnapshotsViewModel(store: store),
                                 snapshots: snapshots)
        // Then
        let listElements = try getListElements(in: view)
        XCTAssertEqual(listElements.count, snapshots.count)
        try snapshots.indices.forEach {
            let navigationLink = try listElements.navigationLink($0)
            XCTAssertEqual(try navigationLink.view(SnapshotView.self).actualView().snapshot, snapshots[$0])
            XCTAssertEqual(try navigationLink.label().hStack().text(0).string(),
                           snapshots[$0].actionData.name)
        }
    }

    func testTimeBackgroundColor() throws {
        // Given
        let view = SnapshotsView(model: SnapshotsViewModel(store: store), snapshots: snapshots)
        // Then
        XCTAssertEqual(view.timeBackgroundColor(for: .dark), Color(.darkGray))
        XCTAssertEqual(view.timeBackgroundColor(for: .light), Color(.init(white: 0.9, alpha: 1)))
    }

    private func getHStack(in view: SnapshotsView) throws -> InspectableView<ViewType.HStack> {
        return try view.inspect().hStack()
    }

    private func getListElements(in view: SnapshotsView) throws -> InspectableView<ViewType.ForEach> {
        return try getHStack(in: view).list(0).forEach(0)
    }
}

extension SnapshotsView: Inspectable {}

private struct TestState: Encodable {
    let counter: Int
}

private struct TestAction: Action {}
private struct OtherTestAction: Action {}
