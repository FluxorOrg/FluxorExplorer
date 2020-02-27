//
//  PeersView.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 16/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

import Fluxor
import MultipeerConnectivity
import SwiftUI

struct PeersView {
    @EnvironmentObject var store: Store<AppState>
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
                                self.store.dispatch(action: SelectPeerAction(peer: peer))
                            }
                        }
                    }
                } else {
                    VStack {
                        Text("No devices connected")
                            .font(.headline)
                        Text("Make sure the application is launched on the device, and the Intercepter is registered in the Store.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
            .navigationBarTitle("Connected devices")
            .onReceive(store.select(Selectors.getPeers), perform: { self.peers = $0 })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .frame(minWidth: 375, maxWidth: UIDevice.current.isMac ? 375 : nil, minHeight: 700, maxHeight: .infinity)
    }
}
