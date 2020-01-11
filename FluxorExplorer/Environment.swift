//
//  Environment.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Fluxor
import FluxorExplorerSnapshot
import MultipeerConnectivity
import UIKit

struct Environment {
    let store: Store<AppState> = {
        let store = Store(initialState: AppState())/*snapshotsByPeer: [MCPeerID(displayName: "MyPhone"): [
            FluxorExplorerSnapshot(action: TestAction(increment: 1295), oldState: ["counter": 42], newState: ["counter": 1337]),
            FluxorExplorerSnapshot(action: OtherTestAction(enabled: true), oldState: ["counter": 1337], newState: ["counter": 42])
        ]]))*/
        store.register(reducer: Reducers.snapshotsReducer)
        return store
    }()
}

var Current = Environment()

struct TestAction: Action {
    let increment: Int
}
struct OtherTestAction: Action {
    let enabled: Bool
}
