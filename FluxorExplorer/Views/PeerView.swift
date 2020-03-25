/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

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
