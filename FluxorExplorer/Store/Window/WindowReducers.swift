/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

let windowReducer = createReducer { (state: inout WindowState, action) -> Void in
    switch action {
    case let action as DidReceiveSnapshotAction:
        var snapshots = state.snapshots.snapshots
        snapshots.append(action.snapshot)
        state.snapshots.snapshots = snapshots
    default:
        ()
    }
}
