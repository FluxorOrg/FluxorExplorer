//
//  Reducers.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Fluxor

let appReducer = createReducer { state, action -> AppState in
    var state = state
    switch action {
    case let action as PeerConnectedAction:
        state.peers.peers.append(action.peer)
    case let action as PeerDisconnectedAction:
        state.peers.peers.removeAll(where: { $0 == action.peer })
    default:
        ()
    }
    return state
}
