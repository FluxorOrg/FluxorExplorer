//
//  Reducers.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 21/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

import Fluxor

let windowReducer = createReducer { state, action -> WindowState in
    var state = state
    switch action {
    case let action as DidReceiveSnapshotAction:
        var snapshots = state.snapshots.snapshots
        snapshots.append(action.snapshot)
        state.snapshots.snapshots = snapshots
    default:
        ()
    }
    return state
}
