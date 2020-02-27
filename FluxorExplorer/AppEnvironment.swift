//
//  AppEnvironment.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Fluxor
import FluxorExplorerSnapshot
import MultipeerConnectivity
import UIKit

struct AppEnvironment {
    var storeByPeers = [String: Store<WindowState>]()
    let store: Store<AppState> = {
        let store = Store(initialState: AppState())
        store.register(reducer: appReducer)
        store.register(effects: AppEffects.self)
        return store
    }()
}

var Current = AppEnvironment()
