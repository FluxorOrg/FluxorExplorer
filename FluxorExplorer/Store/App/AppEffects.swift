/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import UIKit

class AppEffects: Effects {
    let openPeerWindow = createEffectCreator { actions in
        actions
            .ofType(SelectPeerAction.self)
            .sink(receiveValue: { action in
                let userActivity = SceneConfiguration.peer.activity
                userActivity.userInfo = ["peerName": action.peer.displayName]
                Current.application.requestSceneSessionActivation(nil,
                                                                  userActivity: userActivity,
                                                                  options: nil,
                                                                  errorHandler: nil)
            })
    }

    let relayReceivedSnapshot = createEffectCreator { actions in
        actions
            .ofType(DidReceiveSnapshotAction.self)
            .sink(receiveValue: { action in
                let peerName = action.peer.displayName
                let windowStore: Store<WindowState>
                if let theWindowStore = Current.storeByPeers[peerName] {
                    windowStore = theWindowStore
                } else {
                    let initialState = WindowState(peer: PeerState(peerName: peerName))
                    windowStore = Store(initialState: initialState, reducers: [windowReducer])
                    Current.storeByPeers[peerName] = windowStore
                }
                windowStore.dispatch(action: action)
            })
    }
}
