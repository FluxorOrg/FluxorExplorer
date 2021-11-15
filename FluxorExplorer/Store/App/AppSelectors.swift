/*
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

struct Selectors {
    private static let getPeersState = Selector(keyPath: \AppState.peers)
    static let getSelectedPeerId = Selector(keyPath: \AppState.selectedPeerId)
    static let getPeers = Selector.with(getPeersState) { $0.sorted(by: { $0.key < $1.key }).map(\.value) }

    private static let getSelectedPeer = Selector.with(
        getPeersState, getSelectedPeerId) { peers, selectedPeerId -> Peer? in
            guard let selectedPeerId = selectedPeerId else { return nil }
            return peers[selectedPeerId]
        }

    static let getSelectedPeerName = Selector.with(getSelectedPeer, keyPath: \.?.name)
    static let getSelectedPeerSnapshots = Selector.with(getSelectedPeer, keyPath: \.?.snapshots)
    static let getSelectedSnapshot = Selector.with(getSelectedPeer, keyPath: \.?.selectedSnaphot)
}
