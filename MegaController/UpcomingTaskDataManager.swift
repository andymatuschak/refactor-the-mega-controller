//
//  UpcomingTaskDataManager.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import CoreData

class UpcomingTaskDataManager: NSObject, NSFetchedResultsControllerDelegate {
    var taskSections: [[Task]] {
        return resultsCache.sections
    }
    
    var totalNumberOfTasks: Int {
        return taskSections.map { $0.count }.reduce(0, combine: +)
    }
    
    var delegate: UpcomingTaskDataManagerDelegate?
    
    private let coreDataStore = CoreDataStore()
    private var fetchedResultsController: NSFetchedResultsController
    private var resultsCache: UpcomingTaskResultsCache
    
    
    override init() {
        let fetchRequest = NSFetchRequest(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(forTasksWithinNumberOfDays: 10, ofDate: NSDate())
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStore.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! fetchedResultsController.performFetch()

		let managedTasks = fetchedResultsController.fetchedObjects! as! [NSManagedObject]
		resultsCache = UpcomingTaskResultsCache(initialTasksSortedAscendingByDate: managedTasks.map { Task(managedTask: $0) }, baseDate: NSDate())

        super.init()
        
        fetchedResultsController.delegate = self
    }
    
    func deleteTask(task: Task) {
        coreDataStore.managedObjectContext.deleteObject(managedTaskForTask(task))
        try! coreDataStore.managedObjectContext.save()
    }
    
    func createTaskWithTitle(title: String, dueDate: NSDate) {
        let newTask = NSManagedObject(entity: coreDataStore.managedObjectContext.persistentStoreCoordinator!.managedObjectModel.entitiesByName["Task"]!, insertIntoManagedObjectContext: coreDataStore.managedObjectContext)
		newTask.setValue(NSUUID().UUIDString, forKey: "id")
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
		let task = Task(managedTask: anObject as! NSManagedObject)
        switch type {
        case .Insert:
            let insertedIndexPath = resultsCache.insertTask(task)
            delegate?.dataManager(self, didInsertRowAtIndexPath: insertedIndexPath)
        case .Delete:
            let deletedIndexPath = resultsCache.deleteTask(task)
            delegate?.dataManager(self, didDeleteRowAtIndexPath: deletedIndexPath)
        case .Move, .Update:
            fatalError("Unsupported")
        }
    }

	private func managedTaskForTask(task: Task) -> NSManagedObject {
		let fetchRequest = NSFetchRequest(entityName: "Task")
		fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [task.id])
		fetchRequest.fetchLimit = 1
		let results = try! coreDataStore.managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
		return results.first!
	}
}

protocol UpcomingTaskDataManagerDelegate {
    func dataManagerWillChangeContent(dataManager: UpcomingTaskDataManager)
    func dataManagerDidChangeContent(dataManager: UpcomingTaskDataManager)
    func dataManager(dataManager: UpcomingTaskDataManager, didInsertRowAtIndexPath indexPath: NSIndexPath)
    func dataManager(dataManager: UpcomingTaskDataManager, didDeleteRowAtIndexPath indexPath: NSIndexPath)
}
