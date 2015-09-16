//
//  ImminentDueDateTests.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

@testable import MegaController
import XCTest

class ImminentDueDateTests: XCTestCase {
	static let calendar = NSCalendar.currentCalendar()
    static let referenceDate = NSDate(timeIntervalSinceReferenceDate: 0)
	static let oneDayPredicate = NSPredicate(forTasksWithinNumberOfDays: 1, ofDate: referenceDate, calendar: calendar)

    func testPredicateMatchesDatesWithinBounds() {
        XCTAssertTrue(ImminentDueDateTests.oneDayPredicate.evaluateWithObject(["dueDate": NSDate(timeIntervalSinceReferenceDate: 1000)]))
    }
    
    func testPredicateDoesNotMatchFurtherDates() {
        let twoDays = ImminentDueDateTests.calendar.dateByAddingUnit(.Day, value: 2, toDate: ImminentDueDateTests.referenceDate, options: NSCalendarOptions())!
        XCTAssertFalse(ImminentDueDateTests.oneDayPredicate.evaluateWithObject(["dueDate": twoDays]))
    }
}
