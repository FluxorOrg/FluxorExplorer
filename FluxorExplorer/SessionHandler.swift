//
//  SessionHandler.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import FluxorExplorerSnapshot
import MultipeerConnectivity

class SessionHandler: NSObject {
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var session: MCSession!
    var mcServiceBrowser: MCNearbyServiceBrowser!

    func start() {
        mcServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "fluxor-explorer")
        mcServiceBrowser.delegate = self
        mcServiceBrowser.startBrowsingForPeers()
    }
}

extension SessionHandler: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("==MC== Session connected: \(peerID.displayName)")

        case MCSessionState.connecting:
            print("==MC== Session connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("==MC== Session not connected: \(peerID.displayName)")
        @unknown default: break
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("==MC== Session did receive data: \(data), from peer: \(peerID)")
        do {
            let snapshot = try JSONDecoder().decode(FluxorExplorerSnapshot.self, from: data)
            DispatchQueue.main.async {
                Current.store.dispatch(action: DidReceiveSnapshotAction(peerID: peerID, snapshot: snapshot))
            }
        } catch {}
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("==MC== Session did receive stream: \(stream), with name: \(streamName), from peer: \(peerID)")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("==MC== Session did receive resource: \(resourceName), with progress: \(progress), from peer: \(peerID)")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("==MC== Session did receive resource: \(resourceName), from peer: \(peerID), at url: \(String(describing: localURL)), with error: \(String(describing: error))")
    }
}

extension SessionHandler: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        print("==MC== foundPeer", peerID)
        session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("==MC== lostPeer", peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("==MC== didNotStartBrowsingForPeers", error)
    }
}
