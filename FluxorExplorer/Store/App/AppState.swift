/*
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import FluxorExplorerSnapshot
import MultipeerConnectivity.MCPeerID

struct AppState: Encodable {
    var peers = [MCPeerID: Peer]()
    var selectedPeerId: MCPeerID?
}

struct Peer: Encodable, Equatable, Identifiable {
    var id: MCPeerID
    var name: String { id.displayName }
    var snapshots = [FluxorExplorerSnapshot]()
    var selectedSnaphot: FluxorExplorerSnapshot?
}
