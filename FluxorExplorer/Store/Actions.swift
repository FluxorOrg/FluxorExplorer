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

struct DidReceiveSnapshotAction: Action {
    let peerID: MCPeerID
    let snapshot: FluxorExplorerSnapshot
}
