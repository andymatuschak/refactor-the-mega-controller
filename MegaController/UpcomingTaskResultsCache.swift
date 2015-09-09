//
//  UpcomingTaskResultsCache.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import CoreData
import Foundation

struct UpcomingTaskResultsCache {
    var sections: [[NSManagedObject]] = Array(count: UpcomingTaskSection.numberOfSections, repeatedValue: [])
	let baseDate: NSDate
    
	init(initialTasksSortedAscendingByDate: [NSManagedObject], baseDate: NSDate) {
		self.baseDate = baseDate
        for task in initialTasksSortedAscendingByDate {
            sections[sectionIndexForTask(task)].append(task)
        }
    }
    
    mutating func insertTask(task: NSManagedObject) -> NSIndexPath {
        let insertedTaskDate = task.valueForKey("dueDate") as! NSDate
        let sectionIndex = sectionIndexForTask(task)
        let insertionIndex = sections[sectionIndex].indexOf { task in
            let otherTaskDate = task.valueForKey("dueDate") as! NSDate
            return insertedTaskDate.compare(otherTaskDate) == .OrderedAscending
            } ?? sections[sectionIndex].count
        sections[sectionIndex].insert(task, atIndex: insertionIndex)
        
        return NSIndexPath(forRow: insertionIndex, inSection: sectionIndex)
    }
    
    mutating func deleteTask(task: NSManagedObject) -> NSIndexPath {
        let sectionIndex = sectionIndexForTask(task)
        let deletedTaskIndex = sections[sectionIndex].indexOf(task)!
        sections[sectionIndex].removeAtIndex(deletedTaskIndex)
        
        return NSIndexPath(forRow: deletedTaskIndex, inSection: sectionIndex)
    }
    
    private func sectionIndexForTask(task: NSManagedObject) -> Int {
        let dueDate = task.valueForKey("dueDate") as! NSDate
		return UpcomingTaskSection(forTaskDueDate: dueDate, baseDate: baseDate).rawValue
    }
}