//
//  SceneDelegate.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 12/11/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var sessionHandler = SessionHandler()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let rootView = SnapshotsListView()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
            sessionHandler.start()
        }
    }
}
