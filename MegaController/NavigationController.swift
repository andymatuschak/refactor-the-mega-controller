//
//  NavigationController.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/7/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return topViewController
    }
}
