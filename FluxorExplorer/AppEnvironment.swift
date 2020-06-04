/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import UIKit

class AppEnvironment {
    var application: UIApplicationProtocol = UIApplication.shared
}

struct Current {
    static var storeByPeers = [String: Store<WindowState, AppEnvironment>]()
    static var store: Store<AppState, AppEnvironment> = {
        let store = Store(initialState: AppState(), environment: AppEnvironment())
        store.register(reducer: appReducer)
        store.register(effects: AppEffects())
        return store
    }()
}

// MARK: - Support mocking of UIApplication in tests

public protocol UIApplicationProtocol {
    func requestSceneSessionActivation(_ sceneSession: UISceneSession?,
                                       userActivity: NSUserActivity?,
                                       options: UIScene.ActivationRequestOptions?,
                                       errorHandler: ((Error) -> Void)?)
}

extension UIApplication: UIApplicationProtocol {}
