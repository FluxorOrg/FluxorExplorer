//
//  Actions.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Fluxor
import FluxorExplorerSnapshot
import MultipeerConnectivity

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
