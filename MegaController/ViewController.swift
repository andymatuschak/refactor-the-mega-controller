//
//  ViewController.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/7/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var navigationThemeDidChangeHandler: ((NavigationTheme) -> Void)?
    var navigationTheme: NavigationTheme {
        return NavigationTheme(numberOfImminentTasks: upcomingTaskDataManager.totalNumberOfTasks)
    }
    
    fileprivate let upcomingTaskDataManager = UpcomingTaskDataManager()
	fileprivate var upcomingTaskDataManagerTableViewAdapter: UpcomingTaskDataManagerTableViewAdapter<TaskTableViewCell>!

    override func viewDidLoad() {
        super.viewDidLoad()

		upcomingTaskDataManagerTableViewAdapter = UpcomingTaskDataManagerTableViewAdapter(
			tableView: tableView,
			upcomingTaskDataManager: upcomingTaskDataManager,
			cellReuseIdentifier: "Cell",
			cellConfigurationHandler: { cell, task in
				cell.viewData = TaskTableViewCell.ViewData(task: task, relativeToDate: Date())
			},
			didChangeHandler: { [weak self] in self?.updateNavigationBar() }
		)
        upcomingTaskDataManager.delegate = upcomingTaskDataManagerTableViewAdapter
		tableView.dataSource = upcomingTaskDataManagerTableViewAdapter
        
        updateNavigationBar()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func updateNavigationBar() {
        navigationThemeDidChangeHandler?(navigationTheme)
    }

    @IBAction func unwindFromAddController(_ segue: AddCompletionSegue) {
		upcomingTaskDataManager.createTaskWithTitle(segue.taskTitle, dueDate: segue.taskDueDate)
    }
}
