/*
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

class AppEnvironment {
    let sessionHandler: SessionHandlerProtocol

    init(sessionHandler: SessionHandlerProtocol = SessionHandler()) {
        self.sessionHandler = sessionHandler
    }
}
