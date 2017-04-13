//
//  UINavigationBar+Theme.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func applyTheme(_ navigationTheme: NavigationTheme) {
        barTintColor = navigationTheme.barTintColor
        tintColor = navigationTheme.tintColor
        titleTextAttributes = navigationTheme.titleTextAttributes
    }
}
