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
			detailTextLabel!.text = viewData?.timingDescription.lowercased()
		}
	}
}


extension TaskTableViewCell.ViewData {
	init(task: Task, relativeToDate baseDate: Date) {
		self.title = task.title
		self.timingDescription = RelativeTimeDateFormatter().stringForDate(date: task.dueDate, relativeToDate: baseDate )
	}
}
