/**
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import XCTest

extension XCTestCase {
    func waitFor(interval: TimeInterval = 0.1, completion: @escaping (() -> Void)) {
        let expectation = XCTestExpectation(description: debugDescription)
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: interval + 0.1)
    }
}
