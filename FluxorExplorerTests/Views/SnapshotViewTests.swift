/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
@testable import FluxorExplorerSnapshot
import ViewInspector
import XCTest

class SnapshotViewTests: XCTestCase {
    let snapshotWithPayload = FluxorExplorerSnapshot(action: TestAction(increment: 1),
                                                     oldState: TestState(counter: 0),
                                                     newState: TestState(counter: 1),
                                                     date: Date(timeIntervalSince1970: 1586294198))
    let snapshotWithoutPayload = FluxorExplorerSnapshot(action: TestAction(increment: 2),
                                                        oldState: TestState(counter: 1),
                                                        newState: TestState(counter: 3),
                                                        date: Date(timeIntervalSince1970: 1586294098))

    static var originalTimeZone: TimeZone!

    override class func setUp() {
        originalTimeZone = NSTimeZone.default
        NSTimeZone.default = TimeZone(abbreviation: "GMT+2")!
    }

    override class func tearDown() {
        NSTimeZone.default = originalTimeZone
    }

    func testWithPayload() throws {
        // Given
        let view = SnapshotView(snapshot: snapshotWithPayload)
        // Then
        let vStack = try getVStack(in: view)
        XCTAssertEqual(try vStack.text(0).string(), "Time:")
        XCTAssertEqual(try vStack.text(1).string(), "11:16:38 PM GMT+2")
//        ViewInspector doesn't support this right now
//        XCTAssertEqual(try vStack.child(at: 3), "Payload")
//        XCTAssertEqual(try vStack.view(DataStructureView.self, 3).actualView().dataStructure,
//                       snapshotWithPayload.actionData.payload)
        XCTAssertEqual(try vStack.text(4).string(), "State")
        XCTAssertEqual(try vStack.view(DataStructureView.self, 5).actualView().dataStructure,
                       snapshotWithPayload.newState)
    }

    func testWithoutPayload() throws {
        // Given
        let view = SnapshotView(snapshot: snapshotWithoutPayload)
        // Then
        let vStack = try getVStack(in: view)
        XCTAssertEqual(try vStack.text(0).string(), "Time:")
        XCTAssertEqual(try vStack.text(1).string(), "11:14:58 PM GMT+2")
        XCTAssertEqual(try vStack.text(4).string(), "State")
        XCTAssertEqual(try vStack.view(DataStructureView.self, 5).actualView().dataStructure,
                       snapshotWithoutPayload.newState)
    }

    func testPreview() {
        XCTAssertTrue(SnapshotView_Previews.previews is SnapshotView)
    }

    private func getVStack(in view: SnapshotView) throws -> InspectableView<ViewType.VStack> {
        try view.inspect().scrollView().vStack()
    }
}

extension SnapshotView: Inspectable {}
extension DataStructureView: Inspectable {}
