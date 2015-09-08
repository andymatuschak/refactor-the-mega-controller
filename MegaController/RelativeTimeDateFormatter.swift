//
//  RelativeTimeDateFormatter.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import Foundation

struct RelativeTimeDateFormatter {
    let calendar: NSCalendar
    
    init(calendar: NSCalendar = NSCalendar.autoupdatingCurrentCalendar()) {
        self.calendar = calendar
    }
    
    func stringForDate(date: NSDate, relativeToDate baseDate: NSDate) -> String {
        var beginningOfDate: NSDate? = nil
        var beginningOfBaseDate: NSDate? = nil
        
        calendar.rangeOfUnit(.Day, startDate: &beginningOfDate, interval: nil, forDate: date)
        calendar.rangeOfUnit(.Day, startDate: &beginningOfBaseDate, interval: nil, forDate: baseDate)
        let numberOfCalendarDaysBetweenDates = calendar.components(NSCalendarUnit.Day, fromDate: beginningOfBaseDate!, toDate: beginningOfDate!, options: NSCalendarOptions()).day
        
        switch numberOfCalendarDaysBetweenDates {
        case -Int.max ... -2:
            return "\(abs(numberOfCalendarDaysBetweenDates)) days ago"
        case -1:
            return "Yesterday"
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        default:
            return "In \(numberOfCalendarDaysBetweenDates) days"
        }
    }
}