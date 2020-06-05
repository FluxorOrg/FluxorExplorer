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

    func sceneWillResignActive(_ scene: UIScene) {
        if self.startedFromUITest {
            UIApplication.shared.requestSceneSessionDestruction(scene.session, options: nil, errorHandler: nil)
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if self.startedFromUITest {
            setupMockData()
        }
    }

    private var startedFromUITest: Bool {
        #if DEBUG
        // When using scenes, the app isn't relaunched with the environment variable.
        // So we set a user default, to ensure the mock data is setup on subsequent launches.
        let defaultsKey = "STARTED_FROM_UI_TEST"
        if ProcessInfo.processInfo.environment["UI_TESTING"] != nil || UserDefaults.standard.bool(forKey: defaultsKey) {
            UserDefaults.standard.set(true, forKey: defaultsKey)
            return true
        }
        #endif
        return false
    }
}
