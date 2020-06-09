/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import FluxorExplorerSnapshot
import MultipeerConnectivity.MCPeerID

struct PeerConnectedAction: Action {
    let peer: MCPeerID
}

struct PeerDisconnectedAction: Action {
    let peer: MCPeerID
}

struct DidReceiveSnapshotAction: Action {
    let peer: MCPeerID
    let snapshot: FluxorExplorerSnapshot
}

struct SelectPeerAction: Action {
    let peer: MCPeerID
}
