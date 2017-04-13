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

	var taskDueDate: Date {
		return datePicker.date
	}

    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet fileprivate weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
}
