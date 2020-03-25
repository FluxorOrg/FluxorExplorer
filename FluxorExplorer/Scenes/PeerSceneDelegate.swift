/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import SwiftUI
import UIKit

class PeerSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        guard let activity = connectionOptions.userActivities.first(where: {
            $0.activityType == SceneConfiguration.peer.activityIdentifier
        }) else {
            UIApplication.shared.requestSceneSessionDestruction(session, options: nil, errorHandler: nil)
            return
        }
        guard let peerName = activity.userInfo?["peerName"] as? String else { return }
        scene.title = peerName
        let windowState = WindowState(peer: PeerState(peerName: peerName))
        let windowStore = Store(initialState: windowState)
        windowStore.register(reducer: windowReducer)
        Current.storeByPeers[peerName] = windowStore
        let peerView = PeerView()
            .environmentObject(Current.store)
            .environmentObject(windowStore)
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = UIHostingController(rootView: peerView)
        self.window?.makeKeyAndVisible()
    }
}
