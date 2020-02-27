//
//  SceneActivity.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 19/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

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
