//
//  SnapshotsListView.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 21/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import FluxorExplorerSnapshot
import MultipeerConnectivity
import SwiftUI

struct SnapshotsListView {
    var model = Model()
    var didSelect: ((FluxorExplorerSnapshot) -> Void)?
    @State var peerID: MCPeerID?
    @State var snapshots = [FluxorExplorerSnapshot]()
    @State var selectedSnapshot: FluxorExplorerSnapshot?
}

extension SnapshotsListView {
    class Model: ViewModel {}
}

extension SnapshotsListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(snapshots, id: \.date) { snapshot in
                    NavigationLink(destination: SnapshotView(snapshot: snapshot)) {
                        VStack {
                            Text(snapshot.actionData.name)
                            Text(snapshot.date.description)
                        }
                    }
                }
            }
            .navigationBarTitle("Snapshots")
            .onReceive(model.store.select {
                Array($0.snapshotsByPeer.keys).first
            }, perform: {
                self.peerID = $0
            })
            .onReceive(model.store.select {
                guard let localPeerID = self.peerID else { return [] }
                return $0.snapshotsByPeer[localPeerID] ?? []
            }, perform: {
                self.snapshots = $0
            })
        }
    }
}
