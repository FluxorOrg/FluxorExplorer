/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import MultipeerConnectivity

class PeersViewModel: ViewModel<AppState> {
    func select(peer: MCPeerID) {
        store.dispatch(action: SelectPeerAction(peer: peer))
    }
}
