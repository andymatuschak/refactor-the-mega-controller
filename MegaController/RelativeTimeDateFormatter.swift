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
    
    func getNumberOfCalendarDaysBetweenDates(startDate: NSDate, _ endDate: NSDate) ->  Int {
        var beginningOfStartDate: NSDate? = nil
        var beginningOfEndDate: NSDate? = nil
        
        calendar.rangeOfUnit(.Day, startDate: &beginningOfStartDate, interval: nil, forDate: startDate)
        calendar.rangeOfUnit(.Day, startDate: &beginningOfEndDate, interval: nil, forDate: endDate)
        return calendar.components(
            .Day,
            fromDate: beginningOfStartDate!, toDate: beginningOfEndDate!,
            options: NSCalendarOptions()
        ).day
    }
    
    func stringForDate(date: NSDate, relativeToDate baseDate: NSDate) -> String {
        let numberOfCalendarDaysBetweenDates = getNumberOfCalendarDaysBetweenDates(baseDate, date)
        
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