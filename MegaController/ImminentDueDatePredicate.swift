//
//  ImminentDueDatePredicate.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import Foundation

extension NSPredicate {
	convenience init(forTasksWithinNumberOfDays numberOfDays: Int, ofDate date: Date, calendar: Calendar = Calendar.current) {
        self.init(format: "dueDate <= %@", argumentArray: [(calendar as NSCalendar).date(byAdding: .day, value: numberOfDays, to: date, options: NSCalendar.Options())!])
    }
}
