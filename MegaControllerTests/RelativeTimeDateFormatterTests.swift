//
//  RelativeTimeDateFormatterTests.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

@testable import MegaController
import XCTest

class RelativeTimeDateFormatterTests: XCTestCase {
    let calendar = Calendar.current
    let baseDate = Date(timeIntervalSinceReferenceDate: 0)
    
    var dateFormatter: RelativeTimeDateFormatter!
    override func setUp() {
        dateFormatter = RelativeTimeDateFormatter(calendar: calendar)
    }
    
    func testTodayDate() {
        let testDate = (calendar as NSCalendar).date(byAdding: .hour, value: 1, to: baseDate, options: NSCalendar.Options())!
        XCTAssertEqual(dateFormatter.stringForDate(testDate, relativeToDate: baseDate), "Today")
    }
    
    func testTomorrowDate() {
        let testDate = (calendar as NSCalendar).date(byAdding: .day, value: 1, to: baseDate, options: NSCalendar.Options())!
        XCTAssertEqual(dateFormatter.stringForDate(testDate, relativeToDate: baseDate), "Tomorrow")
    }
    
    func testLaterDate() {
        let testDate = (calendar as NSCalendar).date(byAdding: .day, value: 4, to: baseDate, options: NSCalendar.Options())!
        XCTAssertEqual(dateFormatter.stringForDate(testDate, relativeToDate: baseDate), "In 4 days")
    }
}
