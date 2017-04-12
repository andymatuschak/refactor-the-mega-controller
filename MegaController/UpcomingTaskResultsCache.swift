//
//  UpcomingTaskResultsCache.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import Foundation

struct UpcomingTaskResultsCache {
    var sections: [[Task]] = Array(repeating: [], count: UpcomingTaskSection.numberOfSections)
	let baseDate: Date
    
    init(initialTasksSortedAscendingByDate: [Task], baseDate: Date) {
		self.baseDate = baseDate
        for task in initialTasksSortedAscendingByDate {
            sections[sectionIndexForTask(task)].append(task)
        }
    }
    
    mutating func insertTask(_ task: Task) -> IndexPath {
        let insertedTaskDate = task.dueDate
        let sectionIndex = sectionIndexForTask(task)
        let insertionIndex = sections[sectionIndex].index { task in
            let otherTaskDate = task.dueDate
            return insertedTaskDate.compare(otherTaskDate as Date) == .orderedAscending
		} ?? sections[sectionIndex].count
        sections[sectionIndex].insert(task, at: insertionIndex)
        
        return IndexPath(row: insertionIndex, section: sectionIndex)
    }
    
    mutating func deleteTask(_ task: Task) -> IndexPath {
        let sectionIndex = sectionIndexForTask(task)
        let deletedTaskIndex = sections[sectionIndex].index(of: task)!
        sections[sectionIndex].remove(at: deletedTaskIndex)
        
        return IndexPath(row: deletedTaskIndex, section: sectionIndex)
    }
    
    fileprivate func sectionIndexForTask(_ task: Task) -> Int {
        let dueDate = task.dueDate
        return UpcomingTaskSection(forTaskDueDate: dueDate, baseDate: baseDate).rawValue
    }
}
