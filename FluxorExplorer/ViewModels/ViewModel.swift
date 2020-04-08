/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor

class ViewModel<State: Encodable> {
    let store: Store<State>

    init(store: Store<State>) {
        self.store = store
    }
}

extension ViewModel where State == AppState {
    convenience init(appStore: Store<State> = Current.store) {
        self.init(store: appStore)
    }
}
