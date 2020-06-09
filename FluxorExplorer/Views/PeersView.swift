/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import MultipeerConnectivity.MCPeerID
import SwiftUI

struct PeersView {
    var model = PeersViewModel()
    @State var peers = [MCPeerID]()
}

extension PeersView: View {
    var body: some View {
        NavigationView {
            HStack {
                if peers.count > 0 {
                    List {
                        ForEach(peers, id: \.displayName) { peer in
                            Button(peer.displayName) {
                                self.model.select(peer: peer)
                            }
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
            .onReceive(model.store.select(Selectors.getPeers), perform: { self.peers = $0 })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .frame(minWidth: 375, maxWidth: UIDevice.current.isMac ? 375 : nil, minHeight: 700, maxHeight: .infinity)
    }
}
