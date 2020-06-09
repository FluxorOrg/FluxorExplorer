/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import FluxorExplorerSnapshot

struct WindowState: Encodable {
    var peer: PeerState
    var snapshots = SnapshotsState()
}

struct PeerState: Encodable {
    var peerName: String
}

struct SnapshotsState: Encodable {
    var snapshots = [FluxorExplorerSnapshot]()
}
