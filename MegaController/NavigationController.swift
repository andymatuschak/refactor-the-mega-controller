//
//  NavigationController.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/7/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    var statusBarStyle: UIStatusBarStyle = .Default {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }
}
