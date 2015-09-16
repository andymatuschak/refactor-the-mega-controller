//
//  ImminentDueDatePredicate.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import Foundation

extension NSPredicate {
	convenience init(forTasksWithinNumberOfDays numberOfDays: Int, ofDate date: NSDate, calendar: NSCalendar = NSCalendar.currentCalendar()) {
        self.init(format: "dueDate <= %@", argumentArray: [calendar.dateByAddingUnit(.Day, value: numberOfDays, toDate: date, options: NSCalendarOptions())!])
    }
}
