/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

extension Selectors {
    static let getSnapshotsState = Selector(keyPath: \WindowState.snapshots)
    static let getSnapshots = Selector.with(getSnapshotsState) { $0.snapshots }
}
