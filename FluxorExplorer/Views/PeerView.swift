//
//  PeerView.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 12/11/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import FluxorExplorerSnapshot
import SwiftUI

struct PeerView: View {
    var body: some View {
        NavigationView {
            SnapshotsListView()
            Text("Select a snapshot in the list")
        }
    }
}

struct PeerView_Previews: PreviewProvider {
    static var previews: some View {
        PeerView()
    }
}
