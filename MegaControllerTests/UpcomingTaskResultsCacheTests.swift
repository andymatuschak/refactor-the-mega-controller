//
//  UpcomingTaskResultsCacheTests.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/17/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

@testable import MegaController
import XCTest

class UpcomingTaskResultsCacheTests: XCTestCase {

    func testAddingAndDeletingTaskChangesNothing() {
		let originalCache = UpcomingTaskResultsCache(initialTasksSortedAscendingByDate: [], baseDate: Date())
		let task = Task(id: "a", title: "task", dueDate: Date())

		var testCache = originalCache
		testCache.insertTask(task)
		testCache.deleteTask(task)
		for (originalSection, testSection) in zip(originalCache.sections, testCache.sections) {
			XCTAssertEqual(originalSection, testSection)
		}
    }

	func testAddingTaskToEmptySection() {
		var cache = UpcomingTaskResultsCache(initialTasksSortedAscendingByDate: [], baseDate: Date())
		let task = Task(id: "a", title: "task", dueDate: Date())
		cache.insertTask(task)
		XCTAssertEqual(cache.sections[0][0], task)
	}

	func testAddingEarlierTaskToSection() {
		let earlierTask = Task(id: "a", title: "earlier task", dueDate: Date(timeIntervalSinceReferenceDate: 0))
		let laterTask = Task(id: "b", title: "later task", dueDate: Date(timeIntervalSinceReferenceDate: 100))

		var cache = UpcomingTaskResultsCache(initialTasksSortedAscendingByDate: [laterTask], baseDate: Date(timeIntervalSinceReferenceDate: 0))
		cache.insertTask(earlierTask)
		XCTAssertEqual(cache.sections[0], [earlierTask, laterTask])
	}

	func testAddingLaterTaskToSection() {
		let earlierTask = Task(id: "a", title: "earlier task", dueDate: Date(timeIntervalSinceReferenceDate: 0))
		let laterTask = Task(id: "b", title: "later task", dueDate: Date(timeIntervalSinceReferenceDate: 100))

		var cache = UpcomingTaskResultsCache(initialTasksSortedAscendingByDate: [earlierTask], baseDate: Date(timeIntervalSinceReferenceDate: 0))
		cache.insertTask(laterTask)
		XCTAssertEqual(cache.sections[0], [earlierTask, laterTask])
	}

}
