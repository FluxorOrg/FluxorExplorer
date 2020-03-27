/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import MultipeerConnectivity.MCPeerID

struct AppState: Encodable {
    var peers = PeersState()
}

struct PeersState: Encodable {
    var peers = [MCPeerID]()
}
