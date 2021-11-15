/*
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

let appReducer = Reducer<AppState>(
    ReduceOn(Actions.peerConnected) { state, action in
        state.peers[action.payload] = Peer(id: action.payload)
    },
    ReduceOn(Actions.peerDisconnected) { state, action in
        state.peers.removeValue(forKey: action.payload)
    },
    ReduceOn(Actions.selectPeer) { state, action in
        state.selectedPeerId = action.payload
    },
    ReduceOn(Actions.deselectPeer) { state, action in
        if state.selectedPeerId == action.payload {
            state.selectedPeerId = nil
        }
    },
    ReduceOn(Actions.didReceiveSnapshot) { state, action in
        guard var snapshots = state.peers[action.payload.peerId]?.snapshots else { return }
        snapshots.append(action.payload.snapshot)
        state.peers[action.payload.peerId]!.snapshots = snapshots
    },
    ReduceOn(Actions.selectSnapshot) { state, action in
        guard let peerId = action.payload.peerId else { return }
        state.peers[peerId]?.selectedSnaphot = action.payload.snapshot
    },
    ReduceOn(Actions.deselectSnapshot) { state, action in
        guard let peerId = action.payload.peerId else { return }
        if state.peers[peerId]?.selectedSnaphot == action.payload.snapshot {
            state.peers[peerId]?.selectedSnaphot = nil
        }
    }
)
