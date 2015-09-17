//
//  UpcomingTaskDataManagerTableViewAdapter.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/17/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class UpcomingTaskDataManagerTableViewAdapter<CellType: UITableViewCell>: NSObject, UITableViewDataSource, UpcomingTaskDataManagerDelegate {
	private let tableView: UITableView
	private let upcomingTaskDataManager: UpcomingTaskDataManager
	private let cellReuseIdentifier: String
	private let cellConfigurationHandler: (CellType, Task) -> ()
	private let didChangeHandler: () -> Void

	init(tableView: UITableView, upcomingTaskDataManager: UpcomingTaskDataManager, cellReuseIdentifier: String, cellConfigurationHandler: (CellType, Task) -> (), didChangeHandler: () -> Void) {
		self.tableView = tableView
		self.upcomingTaskDataManager = upcomingTaskDataManager
		self.cellReuseIdentifier = cellReuseIdentifier
		self.cellConfigurationHandler = cellConfigurationHandler
		self.didChangeHandler = didChangeHandler

		super.init()
	}

	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		upcomingTaskDataManager.deleteTask(upcomingTaskDataManager.taskSections[indexPath.section].items[indexPath.row])
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return upcomingTaskDataManager.taskSections.count
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return upcomingTaskDataManager.taskSections[section].title
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return upcomingTaskDataManager.taskSections[section].items.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let task = upcomingTaskDataManager.taskSections[indexPath.section].items[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CellType
		cellConfigurationHandler(cell, task)
		return cell
	}

	func dataManagerWillChangeContent(dataManager: UpcomingTaskDataManager) {
		tableView.beginUpdates()
	}

	func dataManagerDidChangeContent(dataManager: UpcomingTaskDataManager) {
		tableView.endUpdates()
		didChangeHandler()
	}

	func dataManager(dataManager: UpcomingTaskDataManager, didInsertRowAtIndexPath indexPath: NSIndexPath) {
		tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
	}

	func dataManager(dataManager: UpcomingTaskDataManager, didDeleteRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
	}
}
