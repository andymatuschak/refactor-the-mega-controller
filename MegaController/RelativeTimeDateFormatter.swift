//
//  RelativeTimeDateFormatter.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import Foundation


extension Date {
  func numberOfDaysUntilDateTime(toDateTime: Date, calendar: Calendar) -> Int {
    let fromDate = calendar.startOfDay(for: self)
    let toDate = calendar.startOfDay(for: toDateTime)
    let difference = calendar.dateComponents([.day], from: fromDate, to: toDate)
    return difference.day!
  }
}

struct RelativeTimeDateFormatter {
    let calendar: Calendar


    init(calendar: Calendar = Calendar.autoupdatingCurrent) {
        self.calendar = calendar
    }
    
    func stringForDate(date: Date, relativeToDate baseDate: Date) -> String {

       let numberOfCalendarDaysBetweenDates = baseDate.numberOfDaysUntilDateTime(toDateTime: date, calendar: calendar)
        
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
