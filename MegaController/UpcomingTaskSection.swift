//
//  UpcomingTaskSection.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import Foundation

enum UpcomingTaskSection: Int {
    case Now
    case Soon
    case Upcoming
    
	init(forTaskDueDate date: NSDate, baseDate: NSDate, calendar: NSCalendar = NSCalendar.currentCalendar()) {
        let numberOfDaysUntilTaskDueDate = calendar.components(NSCalendarUnit.Day, fromDate: baseDate, toDate: date, options: NSCalendarOptions()).day
        switch numberOfDaysUntilTaskDueDate {
        case -Int.max ... 2:
            self = .Now
        case 3...5:
            self = .Soon
        default:
            self = .Upcoming
        }
    }
    
    var title: String {
        switch self {
        case .Now: return "Now"
        case .Soon: return "Soon"
        case .Upcoming: return "Upcoming"
        }
    }
    
    static var numberOfSections: Int {
        return 3
    }
}