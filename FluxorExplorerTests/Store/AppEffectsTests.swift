/*
 * FluxorExplorerTests
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
@testable import FluxorExplorer
import FluxorExplorerSnapshot
import FluxorTestSupport
import MultipeerConnectivity.MCPeerID
import XCTest

class AppEffectsTests: XCTestCase {
    func testStartSessionHandler() throws {
        // Given
        let effects = AppEffects()
        let mockSessionHandler = MockSessionHandler()
        let environment = AppEnvironment(sessionHandler: mockSessionHandler)
        // When
        try EffectRunner.run(effects.startSessionHandler,
                             with: Actions.startSessionHandler(),
                             environment: environment)
        // Then
        XCTAssertTrue(mockSessionHandler.hasStarted)
    }
}

class MockSessionHandler: SessionHandlerProtocol {
    var hasStarted = false

    func start() {
        hasStarted = true
    }
}
