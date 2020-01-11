//
//  Reducers.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Fluxor

struct Reducers {
    static let snapshotsReducer = Reducer<AppState> { state, action in
        var state = state
        switch action {
        case let action as DidReceiveSnapshotAction:
            if var snapshots = state.snapshotsByPeer[action.peerID] {
                snapshots.append(action.snapshot)
                state.snapshotsByPeer[action.peerID] = snapshots
            } else {
                state.snapshotsByPeer[action.peerID] = [action.snapshot]
            }
        default:
            ()
        }
        return state
    }
}
