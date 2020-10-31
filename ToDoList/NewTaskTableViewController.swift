//
//  NewTaskTableViewController.swift
//  ToDoList
//
//  Created by Yaroslav on 25.10.2020.
//  Copyright © 2020 Yaroslav. All rights reserved.
//

import UIKit

class NewTaskTableViewController: UITableViewController {

    @IBOutlet var newTaskTextField: UITextField!
    @IBOutlet var urgencySwitch: UISwitch!
    @IBOutlet var doneButtonEnabled: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonEnabled.isEnabled = false
    }
    

    @IBAction func newTaskEntered(_ sender: UITextField) {
        doneButtonEnabled.isEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
}
