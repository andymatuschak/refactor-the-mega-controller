//
//  UpcomingTaskDataManager.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import CoreData

class UpcomingTaskDataManager: NSObject, NSFetchedResultsControllerDelegate {
    var taskSections: [Section<Task>] {
		return resultsCache.sections.enumerated().map { index, tasks in
			return Section(
				title: UpcomingTaskSection(rawValue: index)!.title,
				items: tasks
			)
		}
    }
    
    var totalNumberOfTasks: Int {
        return taskSections.map { $0.items.count }.reduce(0, +)
    }
    
    var delegate: UpcomingTaskDataManagerDelegate?
    
    fileprivate let coreDataStore = CoreDataStore()
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    fileprivate var resultsCache: UpcomingTaskResultsCache
    
    
    override init() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(forTasksWithinNumberOfDays: 10, ofDate: Date())
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStore.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! fetchedResultsController.performFetch()

		let managedTasks = fetchedResultsController.fetchedObjects! as! [NSManagedObject]
		resultsCache = UpcomingTaskResultsCache(initialTasksSortedAscendingByDate: managedTasks.map { Task(managedTask: $0) }, baseDate: Date())

        super.init()
        
        fetchedResultsController.delegate = self
    }
    
    func deleteTask(_ task: Task) {
        coreDataStore.managedObjectContext.delete(managedTaskForTask(task))
        try! coreDataStore.managedObjectContext.save()
    }
    
    func createTaskWithTitle(_ title: String, dueDate: Date) {
        let newTask = NSManagedObject(entity: coreDataStore.managedObjectContext.persistentStoreCoordinator!.managedObjectModel.entitiesByName["Task"]!, insertInto: coreDataStore.managedObjectContext)
		newTask.setValue(UUID().uuidString, forKey: "id")
        newTask.setValue(title, forKey: "title")
        newTask.setValue(dueDate, forKey: "dueDate")
        try! coreDataStore.managedObjectContext.save()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataManagerWillChangeContent(self)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataManagerDidChangeContent(self)
    }
    
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		let task = Task(managedTask: anObject as! NSManagedObject)
        switch type {
        case .insert:
            let insertedIndexPath = resultsCache.insertTask(task)
            delegate?.dataManager(self, didInsertRowAtIndexPath: insertedIndexPath)
        case .delete:
            let deletedIndexPath = resultsCache.deleteTask(task)
            delegate?.dataManager(self, didDeleteRowAtIndexPath: deletedIndexPath)
        case .move, .update:
            fatalError("Unsupported")
        }
    }

	fileprivate func managedTaskForTask(_ task: Task) -> NSManagedObject {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
		fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [task.id])
		fetchRequest.fetchLimit = 1
		let results = try! coreDataStore.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
		return results.first!
	}
}

struct Section<Item> {
	let title: String
	let items: [Item]
}

protocol UpcomingTaskDataManagerDelegate {
    func dataManagerWillChangeContent(_ dataManager: UpcomingTaskDataManager)
    func dataManagerDidChangeContent(_ dataManager: UpcomingTaskDataManager)
    func dataManager(_ dataManager: UpcomingTaskDataManager, didInsertRowAtIndexPath indexPath: IndexPath)
    func dataManager(_ dataManager: UpcomingTaskDataManager, didDeleteRowAtIndexPath indexPath: IndexPath)
}
