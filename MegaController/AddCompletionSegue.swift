//
//  AddCompletionSegue.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/17/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class AddCompletionSegue: UIStoryboardSegue {
	var taskTitle: String {
		return addViewController.taskTitle
	}

	var taskDueDate: Date {
		return addViewController.taskDueDate as Date
	}

	fileprivate var addViewController: AddViewController {
		return source as! AddViewController
	}
}
