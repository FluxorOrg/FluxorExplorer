//
//  AppDelegate.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 12/11/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let peerConfiguration = SceneConfiguration.peer
        if options.userActivities.contains(where: { $0.activityType == peerConfiguration.activityIdentifier }) {
            return peerConfiguration.sceneConfiguration
        } else {
            return SceneConfiguration.default.sceneConfiguration
        }
    }
}
