/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import ViewInspector
import XCTest

class PeerViewTests: XCTestCase {
    func testDefaultText() throws {
        // Given
        let view = PeerView(store: Store(initialState: WindowState(peer: PeerState(peerName: "Some peer"))))
        // Then
        let navigationView = try view.inspect().navigationView()
        XCTAssertNotNil(try navigationView.view(SnapshotsView.self, 0))
        XCTAssertEqual(try navigationView.text(1).string(), "Select a snapshot in the list")
    }

    func testPreview() {
        XCTAssertTrue(PeerView_Previews.previews is PeerView)
    }
}

extension PeerView: Inspectable {}
