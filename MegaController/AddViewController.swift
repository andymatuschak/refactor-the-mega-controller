//
//  AddViewController.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/7/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

	var taskTitle: String {
		return textField.text!
	}

	var taskDueDate: NSDate {
		return datePicker.date
	}

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(animated: Bool) {
        textField.becomeFirstResponder()
    }
}