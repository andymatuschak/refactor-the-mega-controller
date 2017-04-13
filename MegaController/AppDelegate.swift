//
//  AppDelegate.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/7/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var navigationController: NavigationController {
        return window!.rootViewController as! NavigationController
    }
    
    lazy var primaryViewController: ViewController = {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Primary") as! ViewController
    }()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        primaryViewController.navigationThemeDidChangeHandler = { [weak self] theme in
            if let navigationController = self?.navigationController {
                navigationController.navigationBar.applyTheme(theme)
                navigationController.statusBarStyle = theme.statusBarStyle
            }
        }
        navigationController.viewControllers = [primaryViewController]
    }
}

