/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

let appReducer = createReducer { (state: inout AppState, action) -> Void in
    switch action {
    case let action as PeerConnectedAction:
        state.peers.peers.append(action.peer)
    case let action as PeerDisconnectedAction:
        state.peers.peers.removeAll(where: { $0 == action.peer })
    default:
        ()
    }
}
