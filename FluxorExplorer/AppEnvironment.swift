/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

struct AppEnvironment {
    var storeByPeers = [String: Store<WindowState>]()
    let store: Store<AppState> = {
        let store = Store(initialState: AppState())
        store.register(reducer: appReducer)
        store.register(effects: AppEffects.self)
        return store
    }()
}

// swiftlint:disable:next identifier_name
var Current = AppEnvironment()
