/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import SwiftUI
import UIKit

class PeersSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var sessionHandler = SessionHandler()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let peersView = PeersView()
            .environmentObject(Current.store)
        if let windowScene = scene as? UIWindowScene {
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 375, height: 700)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 375, height: 700)
            self.window = UIWindow(windowScene: windowScene)
            self.window?.rootViewController = UIHostingController(rootView: peersView)
            self.window?.makeKeyAndVisible()
            self.sessionHandler.start()
        }
    }
}
