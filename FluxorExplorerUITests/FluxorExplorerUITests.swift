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
        #if !targetEnvironment(macCatalyst)
        XCUIDevice.shared.orientation = .landscapeLeft
        #endif
        let app = XCUIApplication()
        app.launchEnvironment["UI_TESTING"] = "1"
        app.launch()
        // Select peer
        let peerButton = app.tables.buttons["iPhone 11 Pro"]
        waitForElement(element: peerButton)
        peerButton.tap()
        // Select action
        let predicate = NSPredicate(format: "label CONTAINS[c] 'CompleteTodoAction'")
        let actionButton = app.tables.buttons.containing(predicate).element(boundBy: 0)
        waitForElement(element: actionButton)
        actionButton.tap()
    }
}

extension XCTestCase {
    public func waitForElement(element: XCUIElement, timeout: TimeInterval = 5) {
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
