/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

struct Selectors {
    static let getPeersState = createRootSelector(keyPath: \AppState.peers)

    static let getPeers = createSelector(getPeersState) { Array($0.peers.sorted(by: <)) }
}
