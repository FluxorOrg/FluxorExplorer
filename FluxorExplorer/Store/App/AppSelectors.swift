//
//  Selectors.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 14/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

import Fluxor
import FluxorExplorerSnapshot

struct Selectors {
    static let getPeersState = createRootSelector(keyPath: \AppState.peers)

    static let getPeers = createSelector(getPeersState) { Array($0.peers.sorted(by: <)) }
}
