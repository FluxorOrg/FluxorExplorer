/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

@testable import FluxorExplorer
import ViewInspector
import XCTest

class PeerViewTests: XCTestCase {
    func testDefaultText() throws {
        // Given
        let view = PeerView()
        // Then
        let navigationView = try view.inspect().navigationView()
        XCTAssertNotNil(try navigationView.view(SnapshotsListView.self, 0))
        XCTAssertEqual(try navigationView.text(1).string(), "Select a snapshot in the list")
    }

    func testPreview() {
        XCTAssertTrue(PeerView_Previews.previews is PeerView)
    }
}

extension PeerView: Inspectable {}
