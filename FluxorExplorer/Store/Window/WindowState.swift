//
//  WindowState.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 21/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

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
