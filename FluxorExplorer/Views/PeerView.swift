/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import SwiftUI

struct PeerView: View {
    let store: Store<WindowState>

    var body: some View {
        NavigationView {
            SnapshotsView(model: SnapshotsViewModel(store: store))
            Text("Select a snapshot in the list")
        }
    }
}

struct PeerView_Previews: PreviewProvider {
    static var previews: some View {
        PeerView(store: Store(initialState: WindowState(peer: PeerState(peerName: "Some peer"))))
    }
}
