/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import UIKit

struct AppEnvironment {
    var application: UIApplicationProtocol = UIApplication.shared
    var storeByPeers = [String: Store<WindowState>]()
    var store: Store<AppState> = {
        let store = Store(initialState: AppState())
        store.register(reducer: appReducer)
        store.register(effects: AppEffects())
        return store
    }()
}

// swiftlint:disable:next identifier_name
var Current = AppEnvironment()

// MARK: - Support mocking of UIApplication in tests

public protocol UIApplicationProtocol {
    func requestSceneSessionActivation(_ sceneSession: UISceneSession?,
                                       userActivity: NSUserActivity?,
                                       options: UIScene.ActivationRequestOptions?,
                                       errorHandler: ((Error) -> Void)?)
}

extension UIApplication: UIApplicationProtocol {}
