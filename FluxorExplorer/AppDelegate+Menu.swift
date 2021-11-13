//
//  AppDelegate+Menu.swift
//  FluxorExplorer
//
//  Created by Morten Bjerg Gregersen on 07/06/2020.
//  Copyright © 2020 MoGee. All rights reserved.
//

import UIKit

extension AppDelegate {
    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == .main {
            builder.insertChild(showDevicesListMenu(), atEndOfMenu: .window)
        }
    }

    override func validate(_ command: UICommand) {}

    private func showDevicesListMenu() -> UIMenu {
        let showDevicesListCommand =
            UIKeyCommand(title: "Show Devices List",
                         image: nil,
                         action: #selector(AppDelegate.showDevicesList),
                         input: "D",
                         modifierFlags: .command,
                         propertyList: nil)
        let showDevicesListMenu =
            UIMenu(title: "",
                   image: nil,
                   identifier: UIMenu.Identifier("dev.fluxor.Explorer.menus.showDevicesList"),
                   options: .displayInline,
                   children: [showDevicesListCommand])
        return showDevicesListMenu
    }
}
