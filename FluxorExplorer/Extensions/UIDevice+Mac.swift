//
//  UIDevice+Mac.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 21/01/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

import UIKit

extension UIDevice {
    var isMac: Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return false
        #endif
    }
}
