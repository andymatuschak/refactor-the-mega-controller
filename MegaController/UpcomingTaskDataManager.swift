//
//  UpcomingTaskDataManager.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import CoreData

class UpcomingTaskDataManager: NSObject, NSFetchedResultsControllerDelegate {
    var taskSections: [[NSManagedObject]] = [[], [], []]
    var totalNumberOfTasks: Int {
        return taskSections.map { $0.count }.reduce(0, combine: +)
    }
    
    var delegate: UpcomingTaskDataManagerDelegate?
    
    private let coreDataStore = CoreDataStore()
    private var fetchedResultsController: NSFetchedResultsController
    
    
    override init() {
        let fetchRequest = NSFetchRequest(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(forTasksWithinNumberOfDays: 10, ofDate: NSDate())
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStore.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        
        for task in fetchedResultsController.fetchedObjects! as! [NSManagedObject] {
            taskSections[sectionIndexForTask(task)].append(task)
        }
    }
    
    func deleteTask(task: NSManagedObject) {
        coreDataStore.managedObjectContext.deleteObject(task)
        try! coreDataStore.managedObjectContext.save()
    }
    
    func createTaskWithTitle(title: String, dueDate: NSDate) {
        let newTask = NSManagedObject(entity: coreDataStore.managedObjectContext.persistentStoreCoordinator!.managedObjectModel.entitiesByName["Task"]!, insertIntoManagedObjectContext: coreDataStore.managedObjectContext)
        newTask.setValue(title, forKey: "title")
        newTask.setValue(dueDate, forKey: "dueDate")
        try! coreDataStore.managedObjectContext.save()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        delegate?.dataManagerWillChangeContent(self)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate?.dataManagerDidChangeContent(self)
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
            
            delegate?.dataManager(self, didInsertRowAtIndexPath: NSIndexPath(forRow: insertionIndex, inSection: sectionIndex))
        case .Delete:
            let sectionIndex = sectionIndexForTask(task)
            let deletedTaskIndex = taskSections[sectionIndex].indexOf(task)!
            taskSections[sectionIndex].removeAtIndex(deletedTaskIndex)
            
            delegate?.dataManager(self, didDeleteRowAtIndexPath: NSIndexPath(forRow: deletedTaskIndex, inSection: sectionIndex))
        case .Move, .Update:
            fatalError("Unsupported")
        }
    }
    
    // TODO: Extract me.
    private func sectionIndexForTask(task: NSManagedObject) -> Int {
        let dueDate = task.valueForKey("dueDate") as! NSDate
		return UpcomingTaskSection(forTaskDueDate: dueDate, baseDate: NSDate()).rawValue
    }
}

protocol UpcomingTaskDataManagerDelegate {
    func dataManagerWillChangeContent(dataManager: UpcomingTaskDataManager)
    func dataManagerDidChangeContent(dataManager: UpcomingTaskDataManager)
    func dataManager(dataManager: UpcomingTaskDataManager, didInsertRowAtIndexPath indexPath: NSIndexPath)
    func dataManager(dataManager: UpcomingTaskDataManager, didDeleteRowAtIndexPath indexPath: NSIndexPath)
}
