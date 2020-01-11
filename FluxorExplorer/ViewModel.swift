//
//  ViewModel.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/12/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Fluxor

class ViewModel {
    let store: Store<AppState>

    init(store: Store<AppState> = Current.store) {
        self.store = store
    }
}
