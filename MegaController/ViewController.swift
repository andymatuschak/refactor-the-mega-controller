//
//  ViewController.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/7/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    private var fetchedResultsController: NSFetchedResultsController?
    var navigationThemeDidChangeHandler: ((NavigationTheme) -> Void)?
    var navigationTheme: NavigationTheme {
        return NavigationTheme(numberOfImminentTasks: fetchedResultsController?.fetchedObjects?.count ?? 0)
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("MegaController", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            fatalError("Couldn't load database: \(error)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    private var taskSections: [[NSManagedObject]] = [[], [], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(forTasksWithinNumberOfDays: 10, ofDate: NSDate())
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController!.delegate = self
        try! fetchedResultsController!.performFetch()
        
        for task in fetchedResultsController!.fetchedObjects! as! [NSManagedObject] {
            taskSections[sectionIndexForTask(task)].append(task)
        }
        
        updateNavigationBar()
    }
    
    private func sectionIndexForTask(task: NSManagedObject) -> Int {
        let date = task.valueForKey("dueDate") as! NSDate
        let numberOfDaysUntilTaskDueDate = NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: NSDate(), toDate: date, options: NSCalendarOptions()).day
        switch numberOfDaysUntilTaskDueDate {
        case -Int.max ... 2:
            return 0
        case 3...5:
            return 1
        default:
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        managedObjectContext.deleteObject(taskSections[indexPath.section][indexPath.row])
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return taskSections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Now"
        case 1:
            return "Soon"
        case 2:
            return "Upcoming"
        default:
            fatalError("Unexpected section")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskSections[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = taskSections[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = task.valueForKey("title") as! String?
        
        let taskDate = task.valueForKey("dueDate") as! NSDate
        cell.detailTextLabel!.text = RelativeTimeDateFormatter().stringForDate(taskDate, relativeToDate: NSDate()).lowercaseString
        
        return cell
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        
        updateNavigationBar()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		let task = anObject as! NSManagedObject
        switch type {
        case .Insert:
            let insertedTaskDate = anObject.valueForKey("dueDate") as! NSDate
            let sectionIndex = sectionIndexForTask(task)
            let insertionIndex = taskSections[sectionIndex].indexOf { task in
                let otherTaskDate = task.valueForKey("dueDate") as! NSDate
                return insertedTaskDate.compare(otherTaskDate) == .OrderedAscending
            } ?? taskSections[sectionIndex].count
            taskSections[sectionIndex].insert(task, atIndex: insertionIndex)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: insertionIndex, inSection: sectionIndex)], withRowAnimation: .Automatic)
        case .Delete:
            let sectionIndex = sectionIndexForTask(task)
            let deletedTaskIndex = taskSections[sectionIndex].indexOf(task)!
            taskSections[sectionIndex].removeAtIndex(deletedTaskIndex)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: deletedTaskIndex, inSection: sectionIndex)], withRowAnimation: .Automatic)
        case .Move, .Update:
            fatalError("Unsupported")
        }
    }
    
    func updateNavigationBar() {
        navigationThemeDidChangeHandler?(navigationTheme)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is AddViewController {
            segue.destinationViewController.modalPresentationStyle = .OverFullScreen
            segue.destinationViewController.transitioningDelegate = self
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) is AddViewController {
            let addView = transitionContext.viewForKey(UITransitionContextToViewKey)
            addView!.alpha = 0
            transitionContext.containerView()!.addSubview(addView!)
            UIView.animateWithDuration(0.4, animations: {
                addView!.alpha = 1.0
            }, completion: { didComplete in
                transitionContext.completeTransition(didComplete)
            })
        } else if transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) is AddViewController {
            let addView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            UIView.animateWithDuration(0.4, animations: {
                addView!.alpha = 0.0
            }, completion: { didComplete in
                transitionContext.completeTransition(didComplete)
            })
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    @IBAction func unwindFromAddController(sender: UIStoryboardSegue) {
        let addViewController = (sender.sourceViewController as! AddViewController)
        
        let newTask = NSManagedObject(entity: managedObjectContext.persistentStoreCoordinator!.managedObjectModel.entitiesByName["Task"]!, insertIntoManagedObjectContext: managedObjectContext)
        newTask.setValue(addViewController.textField.text, forKey: "title")
        newTask.setValue(addViewController.datePicker.date, forKey: "dueDate")
        try! managedObjectContext.save()
    }
}
