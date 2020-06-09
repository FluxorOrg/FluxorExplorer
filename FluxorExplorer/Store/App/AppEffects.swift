/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import UIKit

class AppEffects: Effects {
    typealias Environment = AppEnvironment

    let openPeerWindow = Effect<Environment>.nonDispatching { actions, environment in
        actions
            .ofType(SelectPeerAction.self)
            .sink(receiveValue: { action in
                let userActivity = SceneConfiguration.peer.activity
                userActivity.userInfo = ["peerName": action.peer.displayName]
                environment.application.requestSceneSessionActivation(nil,
                                                                      userActivity: userActivity,
                                                                      options: nil,
                                                                      errorHandler: nil)
            })
    }

    let relayReceivedSnapshot = Effect<Environment>.nonDispatching { actions, _ in
        actions
            .ofType(DidReceiveSnapshotAction.self)
            .sink(receiveValue: { action in
                let peerName = action.peer.displayName
                let windowStore: Store<WindowState, AppEnvironment>
                if let theWindowStore = Current.storeByPeers[peerName] {
                    windowStore = theWindowStore
                } else {
                    let initialState = WindowState(peer: PeerState(peerName: peerName))
                    windowStore = Store(initialState: initialState,
                                        environment: AppEnvironment(),
                                        reducers: [windowReducer])
                    Current.storeByPeers[peerName] = windowStore
                }
                windowStore.dispatch(action: action)
            })
    }
}
