//
//  NavigationTheme.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

enum NavigationTheme {
    case Normal
    case Warning
    case Doomed
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .Normal: return .Default
        case .Warning, .Doomed: return .LightContent
        }
    }
    
    var barTintColor: UIColor? {
        switch self {
        case .Normal:
            return nil
        case .Warning:
            return UIColor(red: 235/255, green: 156/255, blue: 77/255, alpha: 1.0)
        case .Doomed:
            return UIColor(red: 248/255, green: 73/255, blue: 68/255, alpha: 1.0)
        }
    }
    
    var titleTextAttributes: [String: NSObject]? {
        switch self {
        case .Normal:
            return nil
        case .Warning, .Doomed:
            return [NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    
    var tintColor: UIColor? {
        switch self {
        case .Normal:
            return nil
        case .Warning, .Doomed:
            return UIColor.whiteColor()
        }
    }
}

extension NavigationTheme {
    init(numberOfImminentTasks: Int) {
        switch numberOfImminentTasks {
        case -Int.max ... 3:
            self = .Normal
        case 4...9:
            self = .Warning
        default:
            self = .Doomed
        }
    }
}
