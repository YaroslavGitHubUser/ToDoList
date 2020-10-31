//
//  EditViewController.swift
//  ToDoList
//
//  Created by Yaroslav on 30.10.2020.
//  Copyright © 2020 Yaroslav. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    var task: Task?
    var indexPathInfo: IndexPath?
   
    @IBOutlet var editTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTextField.text = task?.task
    }

    
}
