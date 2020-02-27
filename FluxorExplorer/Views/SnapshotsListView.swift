//
//  SnapshotsListView.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 21/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Fluxor
import FluxorExplorerSnapshot
import MultipeerConnectivity
import SwiftUI

struct SnapshotsListView {
    @EnvironmentObject var windowStore: Store<WindowState>
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var snapshots = [FluxorExplorerSnapshot]()

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

    var timeBackgroundColor: Color {
        Color(self.colorScheme == .dark ? .darkGray : .init(white: 0.9, alpha: 1))
    }
}

extension SnapshotsListView: View {
    var body: some View {
        List {
            ForEach(snapshots, id: \.date) { snapshot in
                NavigationLink(destination: SnapshotView(snapshot: snapshot)) {
                    HStack {
                        Text(snapshot.actionData.name)
                        Spacer()
                        Text(self.dateFormatter.string(from: snapshot.date))
                            .padding(6)
                            .background(self.timeBackgroundColor)
                            .cornerRadius(6)
                    }
                }
            }
        }
        .navigationBarTitle("Snapshots")
        .onReceive(windowStore.select(Selectors.getSnapshots), perform: { self.snapshots = $0 })
    }
}
