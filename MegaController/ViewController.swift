//
//  ViewController.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/7/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UpcomingTaskDataManagerDelegate {

    var navigationThemeDidChangeHandler: ((NavigationTheme) -> Void)?
    var navigationTheme: NavigationTheme {
        return NavigationTheme(numberOfImminentTasks: upcomingTaskDataManager.totalNumberOfTasks)
    }
    
    private let upcomingTaskDataManager = UpcomingTaskDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingTaskDataManager.delegate = self
        
        updateNavigationBar()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        upcomingTaskDataManager.deleteTask(upcomingTaskDataManager.taskSections[indexPath.section][indexPath.row])
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return upcomingTaskDataManager.taskSections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UpcomingTaskSection(rawValue: section)!.title
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingTaskDataManager.taskSections[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = upcomingTaskDataManager.taskSections[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TaskTableViewCell
		cell.viewData = TaskTableViewCell.ViewData(task: task, relativeToDate: NSDate())
        return cell
    }
    
    func dataManagerWillChangeContent(dataManager: UpcomingTaskDataManager) {
        tableView.beginUpdates()
    }

    func dataManagerDidChangeContent(dataManager: UpcomingTaskDataManager) {
        tableView.endUpdates()
        
        updateNavigationBar()
    }
    
    func dataManager(dataManager: UpcomingTaskDataManager, didInsertRowAtIndexPath indexPath: NSIndexPath) {
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    func dataManager(dataManager: UpcomingTaskDataManager, didDeleteRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func updateNavigationBar() {
        navigationThemeDidChangeHandler?(navigationTheme)
    }

    @IBAction func unwindFromAddController(segue: AddCompletionSegue) {
		upcomingTaskDataManager.createTaskWithTitle(segue.taskTitle, dueDate: segue.taskDueDate)
    }
}
