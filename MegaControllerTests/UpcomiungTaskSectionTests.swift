//
//  UpcomiungTaskSectionTests.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/17/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

@testable import MegaController
import XCTest

class UpcomiungTaskSectionTests: XCTestCase {

	func testTaskAtBaseDateIsInNowSection() {
		let testDate = NSDate()
		XCTAssertEqual(UpcomingTaskSection(forTaskDueDate: testDate, baseDate: testDate), UpcomingTaskSection.Now)
	}

	func testTaskInSeveralDaysIsInSoonSection() {
		let baseDate = NSDate()
		let calendar = NSCalendar.currentCalendar()
		let soonDate = calendar.dateByAddingUnit(.Day, value: 3, toDate: baseDate, options: NSCalendarOptions())!
		XCTAssertEqual(UpcomingTaskSection(forTaskDueDate: soonDate, baseDate: baseDate, calendar: calendar), UpcomingTaskSection.Soon)
	}

	func testTaskInManyDaysIsInUpcomingSection() {
		let baseDate = NSDate()
		let calendar = NSCalendar.currentCalendar()
		let upcomingDate = calendar.dateByAddingUnit(.Day, value: 10, toDate: baseDate, options: NSCalendarOptions())!
		XCTAssertEqual(UpcomingTaskSection(forTaskDueDate: upcomingDate, baseDate: baseDate, calendar: calendar), UpcomingTaskSection.Upcoming)
	}
}
