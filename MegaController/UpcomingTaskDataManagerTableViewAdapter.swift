//
//  UpcomingTaskDataManagerTableViewAdapter.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/17/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class UpcomingTaskDataManagerTableViewAdapter<CellType: UITableViewCell>: NSObject, UITableViewDataSource, UpcomingTaskDataManagerDelegate {
	fileprivate let tableView: UITableView
	fileprivate let upcomingTaskDataManager: UpcomingTaskDataManager
	fileprivate let cellReuseIdentifier: String
	fileprivate let cellConfigurationHandler: (CellType, Task) -> ()
	fileprivate let didChangeHandler: () -> Void

	init(tableView: UITableView, upcomingTaskDataManager: UpcomingTaskDataManager, cellReuseIdentifier: String, cellConfigurationHandler: @escaping (CellType, Task) -> (), didChangeHandler: @escaping () -> Void) {
		self.tableView = tableView
		self.upcomingTaskDataManager = upcomingTaskDataManager
		self.cellReuseIdentifier = cellReuseIdentifier
		self.cellConfigurationHandler = cellConfigurationHandler
		self.didChangeHandler = didChangeHandler

		super.init()
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		upcomingTaskDataManager.deleteTask(upcomingTaskDataManager.taskSections[indexPath.section].items[indexPath.row])
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return upcomingTaskDataManager.taskSections.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return upcomingTaskDataManager.taskSections[section].title
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return upcomingTaskDataManager.taskSections[section].items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let task = upcomingTaskDataManager.taskSections[indexPath.section].items[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CellType
		cellConfigurationHandler(cell, task)
		return cell
	}

	func dataManagerWillChangeContent(_ dataManager: UpcomingTaskDataManager) {
		tableView.beginUpdates()
	}

	func dataManagerDidChangeContent(_ dataManager: UpcomingTaskDataManager) {
		tableView.endUpdates()
		didChangeHandler()
	}

	func dataManager(_ dataManager: UpcomingTaskDataManager, didInsertRowAtIndexPath indexPath: IndexPath) {
		tableView.insertRows(at: [indexPath], with: .automatic)
	}

	func dataManager(_ dataManager: UpcomingTaskDataManager, didDeleteRowAtIndexPath indexPath: IndexPath) {
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
}
