/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import FluxorExplorerSnapshot
import SwiftUI

struct SnapshotsView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject private var store: Store<AppState, AppEnvironment>
    @StoreValue(FluxorExplorerApp.store, Selectors.getSelectedPeerId) private var peerId
    @StoreValue(FluxorExplorerApp.store, Selectors.getSelectedPeerSnapshots) private var snapshots

    func timeBackgroundColor(for colorScheme: ColorScheme) -> Color {
        Color(colorScheme == .dark ? .darkGray : .init(white: 0.9, alpha: 1))
    }

    var body: some View {
        HStack {
            if let snapshots = snapshots, snapshots.count > 0 {
                List {
                    ForEach(snapshots, id: \.date) { snapshot in
                        let isActive = store.binding(get: Selector.with(Selectors.getSelectedSnapshot, projector: { $0 == snapshot }),
                                                     send: {
                                                         let payload = (peerId: peerId, snapshot: snapshot)
                                                         return $0 ? Actions.selectSnapshot(payload: payload) : Actions.deselectSnapshot(payload: payload)
                                                     })
                        NavigationLink(destination: SnapshotView(snapshot: snapshot), isActive: isActive) {
                            VStack(alignment: .leading) {
                                Text(snapshot.actionData.name)
                                Text(snapshot.date.formatted(date: .omitted, time: .shortened))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Text("No snapshots yet")
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Snapshots")
    }
}
