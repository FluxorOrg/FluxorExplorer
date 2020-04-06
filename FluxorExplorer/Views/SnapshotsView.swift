/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import FluxorExplorerSnapshot
import SwiftUI

struct SnapshotsView {
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

extension SnapshotsView: View {
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
