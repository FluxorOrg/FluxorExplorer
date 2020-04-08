/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

let windowReducer = createReducer(
    reduceOn(DidReceiveSnapshotAction.self) { (state: inout WindowState, action) in
        var snapshots = state.snapshots.snapshots
        snapshots.append(action.snapshot)
        state.snapshots.snapshots = snapshots
    }
)
