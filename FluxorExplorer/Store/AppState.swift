//
//  AppState.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import FluxorExplorerSnapshot
import MultipeerConnectivity

struct AppState: Encodable {
    var snapshotsByPeer = [MCPeerID: [FluxorExplorerSnapshot]]()
}

extension MCPeerID: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.displayName, forKey: .displayName)
    }
    
    enum CodingKeys: String, CodingKey {
        case displayName
    }
}
