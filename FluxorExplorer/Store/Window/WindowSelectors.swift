/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

extension Selectors {
    static let getSnapshotsState = createRootSelector(keyPath: \WindowState.snapshots)
    static let getSnapshots = createSelector(getSnapshotsState) { $0.snapshots }
}
