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
                UIApplication.shared.requestSceneSessionActivation(nil,
                                                                   userActivity: userActivity,
                                                                   options: nil,
                                                                   errorHandler: nil)
            })
    }

    let relayReceivedSnapshot = createEffectCreator { actions in
        actions
            .ofType(DidReceiveSnapshotAction.self)
            .sink(receiveValue: { action in
                Current.storeByPeers[action.peer.displayName]?.dispatch(action: action)
            })
    }
}
