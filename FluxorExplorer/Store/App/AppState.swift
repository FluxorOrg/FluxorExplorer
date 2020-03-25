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

extension MCPeerID: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.displayName, forKey: .displayName)
    }

    enum CodingKeys: String, CodingKey {
        case displayName
    }
}

extension MCPeerID: Comparable {
    public static func < (lhs: MCPeerID, rhs: MCPeerID) -> Bool {
        lhs.displayName < rhs.displayName
    }
}
