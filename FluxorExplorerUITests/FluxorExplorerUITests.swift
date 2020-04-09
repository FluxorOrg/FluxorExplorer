/**
 * FluxorExplorerUITests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import XCTest

class FluxorExplorerUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testNavigation() {
        XCUIDevice.shared.orientation = .landscapeLeft
        let app = XCUIApplication()
        app.launchEnvironment["UI_TESTING"] = "1"
        app.launch()
        // Select peer
        let peerButton = app.tables.buttons["Peer 1"]
        waitForElement(element: peerButton)
        peerButton.tap()
        // Select action
        let predicate = NSPredicate(format: "label CONTAINS[c] 'TestAction'")
        let actionButton = app.tables.buttons.containing(predicate).element(boundBy: 0)
        waitForElement(element: actionButton)
        actionButton.tap()
        // Go back
        app.navigationBars["TestAction"].buttons["Snapshots"].tap()
    }
}

extension XCTestCase {
    public func waitForElement(element: XCUIElement, timeout: TimeInterval = 5) {
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
