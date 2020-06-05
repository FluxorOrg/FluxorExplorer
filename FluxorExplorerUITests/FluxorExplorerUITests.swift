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
        setupSnapshot(app)
        // Select peer
        let peerButton = app.tables.buttons["iPhone 11 Pro"]
        waitForElement(element: peerButton)
        peerButton.tap()
        
        
        
        
        app.otherElements["SideAppDivider"].tap()
        let element = app.otherElements["FluxorExplorer, iPhone 11 Pro"].scrollViews.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        element.swipeUp()
        
        // Select action
        let predicate = NSPredicate(format: "label CONTAINS[c] 'CompleteTodoAction'")
        let actionButton = app.tables.buttons.containing(predicate).element(boundBy: 0)
        waitForElement(element: actionButton)
        actionButton.tap()
        // Take screenshot
        snapshot("1-Selected-Action")
        // Terminate
        app.terminate()
        
        
        
    }
}

extension XCTestCase {
    public func waitForElement(element: XCUIElement, timeout: TimeInterval = 35) {
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
