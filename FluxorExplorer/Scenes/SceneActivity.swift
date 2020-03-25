/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

import UIKit

enum SceneConfiguration {
    case `default`
    case peer

    var activityIdentifier: String { self == .default ? "explorer.fluxor.default" : "explorer.fluxor.peer" }

    var activity: NSUserActivity { NSUserActivity(activityType: activityIdentifier) }

    var configurationName: String { self == .default ? "Default Configuration" : "Peer Configuration" }

    var sceneConfiguration: UISceneConfiguration {
        UISceneConfiguration(name: configurationName, sessionRole: .windowApplication)
    }
}
