/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

let appReducer = createReducer(
    reduceOn(PeerConnectedAction.self) { (state: inout AppState, action) in
        state.peers.peers.append(action.peer)
    },
    reduceOn(PeerDisconnectedAction.self) { (state: inout AppState, action) in
        state.peers.peers.removeAll(where: { $0 == action.peer })
    }
)
