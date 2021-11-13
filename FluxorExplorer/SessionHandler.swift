/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import FluxorExplorerSnapshot
import MultipeerConnectivity

class SessionHandler: NSObject {
    private let peer: MCPeerID
    private var session: MCSession?
    private var mcServiceBrowser: MCNearbyServiceBrowser

    override init() {
        peer = MCPeerID(displayName: UIDevice.current.name)
        mcServiceBrowser = MCNearbyServiceBrowser(peer: peer, serviceType: "fluxor-explorer")
        super.init()
        mcServiceBrowser.delegate = self
    }

    func start() {
        mcServiceBrowser.startBrowsingForPeers()
    }
}

extension SessionHandler: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            DispatchQueue.main.async {
                FluxorExplorerApp.store.dispatch(action: Actions.peerConnected(payload: peerID))
            }
        case .notConnected:
            DispatchQueue.main.async {
                FluxorExplorerApp.store.dispatch(action: Actions.peerDisconnected(payload: peerID))
            }
        default: break
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let snapshot = try JSONDecoder().decode(FluxorExplorerSnapshot.self, from: data)
            DispatchQueue.main.async {
                FluxorExplorerApp.store.dispatch(action: Actions.didReceiveSnapshot(payload: (peerId: peerID, snapshot: snapshot)))
            }
        } catch {}
    }

    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {}
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {}
}

extension SessionHandler: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        let session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
        self.session = session
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
}
