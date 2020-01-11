//
//  RootView.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 12/11/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import FluxorExplorerSnapshot
import SwiftUI

struct RootView {
    var model = Model()
    @State var selectedSnapshot: FluxorExplorerSnapshot?
}

extension RootView {
    class Model: ViewModel {}
}

extension RootView: View {
    var body: some View {
//        NavigationView {
            SnapshotsListView(didSelect: { snapshot in
                self.selectedSnapshot = snapshot
            })
//            .navigationViewStyle(DoubleColumnNavigationViewStyle())
//            SnapshotView(snapshot: selectedSnapshot)
//        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
