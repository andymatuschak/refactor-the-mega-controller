//
//  Task.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/17/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import CoreData
import Foundation

struct Task: Equatable {
	var id: String
	var title: String
	var dueDate: NSDate
}

func ==(lhs: Task, rhs: Task) -> Bool {
	return lhs.id == rhs.id && lhs.title == rhs.title && lhs.dueDate == rhs.dueDate
}

extension Task {
	init(managedTask: NSManagedObject) {
		self.id = managedTask.valueForKey("id") as! String
		self.title = managedTask.valueForKey("title") as! String
		self.dueDate = managedTask.valueForKey("dueDate") as! NSDate
	}
}
