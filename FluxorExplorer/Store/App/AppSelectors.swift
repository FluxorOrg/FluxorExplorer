/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

struct Selectors {
    static let getPeersState = Selector(keyPath: \AppState.peers)
    static let getPeers = Selector.with(getPeersState) { Array($0.peers.sorted(by: <)) }
}
