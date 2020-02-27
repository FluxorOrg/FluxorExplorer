//
//  PeersSceneDelegate.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

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
