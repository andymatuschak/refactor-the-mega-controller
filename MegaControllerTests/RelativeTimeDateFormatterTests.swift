//
//  RelativeTimeDateFormatterTests.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

@testable import MegaController
import XCTest


class GetNumberOfCalendarDaysBetweenDatesTests: XCTestCase {
    let calendar = NSCalendar.currentCalendar()
    let baseDate = NSDate(timeIntervalSinceReferenceDate: 0)
    
    var dateFormatter: RelativeTimeDateFormatter!
    override func setUp() {
        dateFormatter = RelativeTimeDateFormatter(calendar: calendar)
    }
    
    func testRelativeToToday() {
        let testDate = calendar.dateByAddingUnit(.Hour, value: 1, toDate: baseDate, options: NSCalendarOptions())!
        XCTAssertEqual(
            dateFormatter.getNumberOfCalendarDaysBetweenDates(baseDate, testDate),
            0
        )
    }
    
    func testRelativeToTomorrow() {
        let testDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: baseDate, options: NSCalendarOptions())!
        XCTAssertEqual(
            dateFormatter.getNumberOfCalendarDaysBetweenDates(baseDate, testDate),
            1
        )
    }
    
    func testRelativeToLaterDate() {
        let testDate = calendar.dateByAddingUnit(.Day, value: 4, toDate: baseDate, options: NSCalendarOptions())!
        XCTAssertEqual(
            dateFormatter.getNumberOfCalendarDaysBetweenDates(baseDate, testDate),
            4
        )
    }
    
    func testRelativeToEarlierDate() {
        let testDate = calendar.dateByAddingUnit(.Day, value: -4, toDate: baseDate, options: NSCalendarOptions())!
        XCTAssertEqual(
            dateFormatter.getNumberOfCalendarDaysBetweenDates(baseDate, testDate),
            -4
        )
    }
}


class RelativeTimeDateFormatterTests: XCTestCase {
    let calendar = NSCalendar.currentCalendar()
    let baseDate = NSDate(timeIntervalSinceReferenceDate: 0)
    
    var dateFormatter: RelativeTimeDateFormatter!
    override func setUp() {
        dateFormatter = RelativeTimeDateFormatter(calendar: calendar)
    }
    
    func testTodayDate() {
        let testDate = calendar.dateByAddingUnit(.Hour, value: 1, toDate: baseDate, options: NSCalendarOptions())!
        XCTAssertEqual(dateFormatter.stringForDate(testDate, relativeToDate: baseDate), "Today")
    }
    
    func testTomorrowDate() {
        let testDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: baseDate, options: NSCalendarOptions())!
        XCTAssertEqual(dateFormatter.stringForDate(testDate, relativeToDate: baseDate), "Tomorrow")
    }
    
    func testLaterDate() {
        let testDate = calendar.dateByAddingUnit(.Day, value: 4, toDate: baseDate, options: NSCalendarOptions())!
        XCTAssertEqual(dateFormatter.stringForDate(testDate, relativeToDate: baseDate), "In 4 days")
    }
}
