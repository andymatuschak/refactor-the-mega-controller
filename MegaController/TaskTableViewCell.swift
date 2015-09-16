//
//  TaskTableViewCell.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/17/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
	struct ViewData {
		let title: String
		let timingDescription: String
	}

	var viewData: ViewData? {
		didSet {
			textLabel!.text = viewData?.title
			detailTextLabel!.text = viewData?.timingDescription.lowercaseString
		}
	}
}


extension TaskTableViewCell.ViewData {
	init(task: Task, relativeToDate baseDate: NSDate) {
		self.title = task.title
		self.timingDescription = RelativeTimeDateFormatter().stringForDate(task.dueDate, relativeToDate: baseDate)
	}
}