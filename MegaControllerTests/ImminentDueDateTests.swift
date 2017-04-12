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
	static let calendar = Calendar.current
    static let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
	static let oneDayPredicate = NSPredicate(forTasksWithinNumberOfDays: 1, ofDate: referenceDate, calendar: calendar)

    func testPredicateMatchesDatesWithinBounds() {
        XCTAssertTrue(ImminentDueDateTests.oneDayPredicate.evaluate(with: ["dueDate": Date(timeIntervalSinceReferenceDate: 1000)]))
    }
    
    func testPredicateDoesNotMatchFurtherDates() {
        let twoDays = (ImminentDueDateTests.calendar as NSCalendar).date(byAdding: .day, value: 2, to: ImminentDueDateTests.referenceDate, options: NSCalendar.Options())!
        XCTAssertFalse(ImminentDueDateTests.oneDayPredicate.evaluate(with: ["dueDate": twoDays]))
    }
}
