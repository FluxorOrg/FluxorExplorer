/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import UIKit

class AppEffects: Effects {
    typealias Environment = AppEnvironment
    
    let startSessionHandler = Effect<AppEnvironment>.nonDispatching { actions, environment in
        actions
            .wasCreated(from: Actions.startSessionHandler)
            .sink { _ in
                environment.sessionHandler.start()
            }
    }
}
