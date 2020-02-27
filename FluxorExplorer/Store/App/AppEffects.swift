//
//  Effects.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

import Combine
import Fluxor
import UIKit

class AppEffects: Effects {
    lazy var effects: [Effect] = [openPeerWindow, relayReceivedSnapshot]
    let actions: ActionPublisher

    required init(_ actions: ActionPublisher) {
        self.actions = actions
    }

    lazy var openPeerWindow = createEffect(
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
    )
    
    lazy var relayReceivedSnapshot = createEffect(
        actions
            .ofType(DidReceiveSnapshotAction.self)
            .sink(receiveValue: { action in
                Current.storeByPeers[action.peer.displayName]?.dispatch(action: action)
            })
    )
}
