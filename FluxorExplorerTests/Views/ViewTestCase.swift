/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2021
 *  MIT license, see LICENSE file for details
 */

@testable import FluxorExplorer
import FluxorTestSupport
import XCTest

class ViewTestCase: XCTestCase {
    var mockStore: MockStore<AppState, AppEnvironment>!

    override func setUp() {
        super.setUp()
        mockStore = MockStore(initialState: AppState(), environment: AppEnvironment())
        FluxorExplorerApp.store = mockStore
    }
}
