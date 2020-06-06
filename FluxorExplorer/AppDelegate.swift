/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let peerConfiguration = SceneConfiguration.peer
        if options.userActivities.contains(where: { $0.activityType == peerConfiguration.activityIdentifier }) {
            return peerConfiguration.sceneConfiguration
        } else {
            return SceneConfiguration.default.sceneConfiguration
        }
    }
}
