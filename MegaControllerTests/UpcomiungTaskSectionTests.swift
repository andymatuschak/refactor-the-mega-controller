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
		let testDate = Date()
		XCTAssertEqual(UpcomingTaskSection(forTaskDueDate: testDate, baseDate: testDate), UpcomingTaskSection.now)
	}

	func testTaskInSeveralDaysIsInSoonSection() {
		let baseDate = Date()
		let calendar = Calendar.current
		let soonDate = (calendar as NSCalendar).date(byAdding: .day, value: 3, to: baseDate, options: NSCalendar.Options())!
		XCTAssertEqual(UpcomingTaskSection(forTaskDueDate: soonDate, baseDate: baseDate, calendar: calendar), UpcomingTaskSection.soon)
	}

	func testTaskInManyDaysIsInUpcomingSection() {
		let baseDate = Date()
		let calendar = Calendar.current
		let upcomingDate = (calendar as NSCalendar).date(byAdding: .day, value: 10, to: baseDate, options: NSCalendar.Options())!
		XCTAssertEqual(UpcomingTaskSection(forTaskDueDate: upcomingDate, baseDate: baseDate, calendar: calendar), UpcomingTaskSection.upcoming)
	}
}
