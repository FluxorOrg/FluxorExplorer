//
//  WindowSelectors.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 21/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

import Fluxor
import FluxorExplorerSnapshot

extension Selectors {
    static let getSnapshotsState = createRootSelector(keyPath: \WindowState.snapshots)

    static let getSnapshots = createSelector(getSnapshotsState) { $0.snapshots }
}
