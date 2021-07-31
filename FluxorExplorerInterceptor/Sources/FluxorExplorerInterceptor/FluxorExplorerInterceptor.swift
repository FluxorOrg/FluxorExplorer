/**
 * FluxorExplorerInterceptor
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import AnyCodable
import Fluxor
import FluxorExplorerSnapshot
import Foundation
import MultipeerConnectivity

/**
 An `Interceptor` which sends `FluxorExplorerSnapshot`s to FluxorExplorer.
 */
public class FluxorExplorerInterceptor<State: Encodable>: NSObject, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    private let serviceType = "fluxor-explorer"
    internal let localPeerID: MCPeerID
    internal var advertiser: MCNearbyServiceAdvertiser
    internal var session: MCSession?
    internal var unsentSnapshots = [FluxorExplorerSnapshot]()

    public var peerDidDisconnect: (MCPeerID) -> Void = { peerID in
        print("FluxorExplorerInterceptor - Peer did disconnect: \(peerID.displayName)")
    }

    public var didFailSendingSnapshot: (FluxorExplorerSnapshot) -> Void = { snapshot in
        print("FluxorExplorerInterceptor - Did fail sending snapshot: \(snapshot)")
    }

    public convenience init(displayName: String) {
        self.init(displayName: displayName, advertiserType: MCNearbyServiceAdvertiser.self)
    }

    internal init(displayName: String, advertiserType: MCNearbyServiceAdvertiser.Type) {
        localPeerID = MCPeerID(displayName: displayName)
        advertiser = advertiserType.init(peer: localPeerID, discoveryInfo: nil, serviceType: serviceType)
        super.init()
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }

    internal func send(snapshot: FluxorExplorerSnapshot) {
        guard let session = session, session.connectedPeers.count > 0 else {
            unsentSnapshots.append(snapshot)
            return
        }
        do {
            let rawData = try JSONEncoder().encode(snapshot)
            try session.send(rawData, toPeers: session.connectedPeers, with: .reliable)
            if let dataIndex = unsentSnapshots.firstIndex(where: { $0 == snapshot }) {
                unsentSnapshots.remove(at: dataIndex)
            }
        } catch {
            didFailSendingSnapshot(snapshot)
        }
    }

    // MARK: - MCNearbyServiceAdvertiserDelegate

    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                           withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let session = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        invitationHandler(true, session)
        self.session = session
    }

    // MARK: - MCSessionDelegate

    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .notConnected {
            peerDidDisconnect(peerID)
        } else if state == .connected, session.connectedPeers.count > 0 {
            unsentSnapshots.forEach(send)
        }
    }

    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {}
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

extension FluxorExplorerInterceptor: Interceptor {
    public func actionDispatched(action: Action, oldState: State, newState: State) {
        guard let action = action as? EncodableAction else { return }
        send(snapshot: FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState))
    }
}
