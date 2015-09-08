//
//  AddViewController.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/7/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(animated: Bool) {
        textField.becomeFirstResponder()
    }
}