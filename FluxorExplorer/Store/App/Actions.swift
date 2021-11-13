/*
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import FluxorExplorerSnapshot
import MultipeerConnectivity.MCPeerID

enum Actions {
    static let startSessionHandler = ActionTemplate(id: "Start Session Handler")
    static let peerConnected = ActionTemplate(id: "Peer connected", payloadType: MCPeerID.self)
    static let peerDisconnected = ActionTemplate(id: "Peer disconnected", payloadType: MCPeerID.self)
    static let selectPeer = ActionTemplate(id: "Select peer", payloadType: MCPeerID.self)
    static let deselectPeer = ActionTemplate(id: "Deelect peer", payloadType: MCPeerID.self)
    static let didReceiveSnapshot = ActionTemplate(id: "Did receive snapshot",
                                                   payloadType: (peerId: MCPeerID,
                                                                 snapshot: FluxorExplorerSnapshot).self)
    static let selectSnapshot = ActionTemplate(id: "Select snapshot",
                                               payloadType: (peerId: MCPeerID?,
                                                             snapshot: FluxorExplorerSnapshot).self)
    static let deselectSnapshot = ActionTemplate(id: "Deelect snapshot",
                                                 payloadType: (peerId: MCPeerID?,
                                                               snapshot: FluxorExplorerSnapshot).self)
}
