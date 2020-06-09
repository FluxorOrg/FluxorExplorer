/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

let appReducer = Reducer<AppState>(
    ReduceOn(PeerConnectedAction.self) { state, action in
        state.peers.peers.append(action.peer)
    },
    ReduceOn(PeerDisconnectedAction.self) { state, action in
        state.peers.peers.removeAll(where: { $0 == action.peer })
    }
)
