/*
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import MultipeerConnectivity.MCPeerID
import SwiftUI

struct PeersView: View {
    @EnvironmentObject private var store: Store<AppState, AppEnvironment>
    @StoreValue(FluxorExplorerApp.store, Selectors.getPeers) private var peers

    var body: some View {
        HStack {
            if peers.count > 0 {
                List(peers) { peer in
                    let isActive = store.binding(get: Selector.with(Selectors.getSelectedPeerId,
                                                                    projector: { $0 == peer.id }),
                                                 send: { $0 ? Actions.selectPeer(payload: peer.id)
                                                     : Actions.deselectPeer(payload: peer.id)
                                                 })
                    NavigationLink(peer.name, isActive: isActive) {
                        SnapshotsView()
                    }
                }
            } else {
                VStack {
                    Text("No devices connected")
                        .font(.headline)
                    Text("Make sure the application is launched and the Interceptor is registered.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .navigationBarTitle("Connected devices")
    }
}
