/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import FluxorExplorerSnapshot
import SwiftUI

struct SnapshotsView {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var model: SnapshotsViewModel
    @State var snapshots = [FluxorExplorerSnapshot]()

    func timeBackgroundColor(for colorScheme: ColorScheme) -> Color {
        Color(colorScheme == .dark ? .darkGray : .init(white: 0.9, alpha: 1))
    }
}

extension SnapshotsView: View {
    var body: some View {
        HStack {
            if snapshots.count > 0 {
                List {
                    ForEach(snapshots, id: \.date) { snapshot in
                        NavigationLink(destination: SnapshotView(snapshot: snapshot)) {
                            HStack {
                                Text(snapshot.actionData.name)
                                Spacer()
                                Text(self.model.dateFormatter.string(from: snapshot.date))
                                    .padding(6)
                                    .background(self.timeBackgroundColor(for: self.colorScheme))
                                    .cornerRadius(6)
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
        .onReceive(model.store.select(Selectors.getSnapshots), perform: { self.snapshots = $0 })
    }
}
