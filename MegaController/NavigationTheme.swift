//
//  NavigationTheme.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

enum NavigationTheme {
    case normal
    case warning
    case doomed
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .normal: return .default
        case .warning, .doomed: return .lightContent
        }
    }
    
    var barTintColor: UIColor? {
        switch self {
        case .normal:
            return nil
        case .warning:
            return UIColor(red: 235/255, green: 156/255, blue: 77/255, alpha: 1.0)
        case .doomed:
            return UIColor(red: 248/255, green: 73/255, blue: 68/255, alpha: 1.0)
        }
    }
    
    var titleTextAttributes: [String: NSObject]? {
        switch self {
        case .normal:
            return nil
        case .warning, .doomed:
            return [NSForegroundColorAttributeName: UIColor.white]
        }
    }
    
    var tintColor: UIColor? {
        switch self {
        case .normal:
            return nil
        case .warning, .doomed:
            return UIColor.white
        }
    }
}

extension NavigationTheme {
    init(numberOfImminentTasks: Int) {
        switch numberOfImminentTasks {
        case -Int.max ... 3:
            self = .normal
        case 4...9:
            self = .warning
        default:
            self = .doomed
        }
    }
}
