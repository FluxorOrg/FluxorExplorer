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
        guard let windowScene = scene as? UIWindowScene else { return }
        let peersView = PeersView()
        let windowSize = CGSize(width: 375, height: 700)
        windowScene.sizeRestrictions?.minimumSize = windowSize
        windowScene.sizeRestrictions?.maximumSize = windowSize
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = UIHostingController(rootView: peersView)
        self.window?.makeKeyAndVisible()
        self.sessionHandler.start()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        #if DEBUG
        setupMockData()
        #endif
    }
}
