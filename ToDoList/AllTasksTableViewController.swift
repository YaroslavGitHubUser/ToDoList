//
//  AllTasksTableViewController.swift
//  ToDoList
//
//  Created by Yaroslav on 22.10.2020.
//  Copyright © 2020 Yaroslav. All rights reserved.
//

import UIKit

class AllTasksTableViewController: UITableViewController {
    
    var urgentTasks: [Task] = []
    var tasksInProgress: [Task] = []
    var doneTasks: [Task] = []
    
    enum emojis: String {
        case urgent = "❗️"
        case inProgress = "💬"
        case done = "✅"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //        print(StorageManager.shared.fetchTasks())
        //        urgentTasks = StorageManager.shared.fetchTasks()[0]
        //        tasksInProgress = StorageManager.shared.fetchTasks()[1]
        //        doneTasks = StorageManager.shared.fetchTasks()[2]
        print(StorageManager.shared.fetchTasksFromFile())
        urgentTasks = StorageManager.shared.fetchTasksFromFile()[0]
        tasksInProgress = StorageManager.shared.fetchTasksFromFile()[1]
        doneTasks = StorageManager.shared.fetchTasksFromFile()[2]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "URGENT"
        case 1: return "IN PROGRESS"
        default: return "DONE"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return urgentTasks.count
        case 1: return tasksInProgress.count
        default: return doneTasks.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        if indexPath.section == 0 {
            cell.taskLabel.text = urgentTasks[indexPath.row].task
            cell.emojiLabel.text = emojis.urgent.rawValue
        } else if indexPath.section == 1 {
            cell.taskLabel.text = tasksInProgress[indexPath.row].task
            cell.emojiLabel.text = emojis.inProgress.rawValue
        } else {
            cell.taskLabel.text = doneTasks[indexPath.row].task
            cell.emojiLabel.text = emojis.done.rawValue
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            urgentTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if indexPath.section == 1 {
            tasksInProgress.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if indexPath.section == 2 {
            doneTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        tableView.reloadData()
        //        StorageManager.shared.saveTask(with: [urgentTasks, tasksInProgress, doneTasks])
        StorageManager.shared.saveTaskToFile(with: [urgentTasks, tasksInProgress, doneTasks])
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            if sourceIndexPath.section == 0 {
                let movedTask = urgentTasks.remove(at: sourceIndexPath.row)
                urgentTasks.insert(movedTask, at: destinationIndexPath.row)
            } else if sourceIndexPath.section == 1 {
                let movedTask = tasksInProgress.remove(at: sourceIndexPath.row)
                tasksInProgress.insert(movedTask, at: destinationIndexPath.row)
            } else if sourceIndexPath.section == 2 {
                let movedTask = doneTasks.remove(at: sourceIndexPath.row)
                doneTasks.insert(movedTask, at: destinationIndexPath.row)
            }
        }
        tableView.reloadData()
        //        StorageManager.shared.saveTask(with: [urgentTasks, tasksInProgress, doneTasks])
        StorageManager.shared.saveTaskToFile(with: [urgentTasks, tasksInProgress, doneTasks])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let urgent = urgentAction(at: indexPath)
        let progress = progressAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done, urgent, progress])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editCellView" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        
        if indexPath.section == 0 {
            let task = urgentTasks[indexPath.row]
            let navigationVC = segue.destination as! UINavigationController
            let editVC = navigationVC.topViewController as! EditViewController
            editVC.indexPathInfo = indexPath
            editVC.task = task
        } else if indexPath.section == 1 {
            let task = tasksInProgress[indexPath.row]
            let navigationVC = segue.destination as! UINavigationController
            let editVC = navigationVC.topViewController as! EditViewController
            editVC.indexPathInfo = indexPath
            editVC.task = task
        } else {
            let task = doneTasks[indexPath.row]
            let navigationVC = segue.destination as! UINavigationController
            let editVC = navigationVC.topViewController as! EditViewController
            editVC.indexPathInfo = indexPath
            editVC.task = task
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "doneSegue" {
            guard let newTaskVC = segue.source as? NewTaskTableViewController else { return }
            if newTaskVC.urgencySwitch.isOn {
                urgentTasks.append(Task(task: newTaskVC.newTaskTextField.text ?? "N/A", isUrgent: true, isDone: false, inProgress: false))
            } else {
                tasksInProgress.append(Task(task: newTaskVC.newTaskTextField.text ?? "N/A", isUrgent: false, isDone: false, inProgress: true))
            }
        } else if segue.identifier == "editSegue" {
            guard let editTaskVC = segue.source as? EditViewController else { return }
            let sourceTaskName = editTaskVC.editTextField.text
            if let selectedIndexPath = editTaskVC.indexPathInfo {
                if selectedIndexPath.section == 0 {
                    urgentTasks[selectedIndexPath.row].task = sourceTaskName ?? "N/A"
                } else if selectedIndexPath.section == 1 {
                    tasksInProgress[selectedIndexPath.row].task = sourceTaskName ?? "N/A"
                } else {
                    doneTasks[selectedIndexPath.row].task = sourceTaskName ?? "N/A"
                }
            }
        }
        tableView.reloadData()
        //        StorageManager.shared.saveTask(with: [urgentTasks, tasksInProgress, doneTasks])
        StorageManager.shared.saveTaskToFile(with: [urgentTasks, tasksInProgress, doneTasks])
    }
    
    // MARK: - Private functions for swipe buttons
    
    private func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, _, completion) in
            
            if indexPath.section == 0 {
                var movedItem = self.urgentTasks.remove(at: indexPath.row)
                movedItem.isUrgent = false
                movedItem.isDone = true
                self.doneTasks.insert(movedItem, at: 0)
            } else if indexPath.section == 1 {
                var movedItem = self.tasksInProgress.remove(at: indexPath.row)
                movedItem.inProgress = false
                movedItem.isDone = true
                self.doneTasks.insert(movedItem, at: 0)
            }
            self.tableView.reloadData()
            //            StorageManager.shared.saveTask(with: [self.urgentTasks, self.tasksInProgress, self.doneTasks])
            StorageManager.shared.saveTaskToFile(with: [self.urgentTasks, self.tasksInProgress, self.doneTasks])
            completion(true)
        }
        
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark.circle")
        return action
    }
    
    
    private func urgentAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Urgent") { (action, _, completion) in
            
            if indexPath.section == 1 {
                var movedItem = self.tasksInProgress.remove(at: indexPath.row)
                movedItem.inProgress = false
                movedItem.isUrgent = true
                self.urgentTasks.insert(movedItem, at: 0)
            } else if indexPath.section == 2 {
                var movedItem = self.doneTasks.remove(at: indexPath.row)
                movedItem.isDone = false
                movedItem.isUrgent = true
                self.urgentTasks.insert(movedItem, at: 0)
            }
            
            self.tableView.reloadData()
            //            StorageManager.shared.saveTask(with: [self.urgentTasks, self.tasksInProgress, self.doneTasks])
            StorageManager.shared.saveTaskToFile(with: [self.urgentTasks, self.tasksInProgress, self.doneTasks])
            completion(true)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "exclamationmark.square")
        return action
    }
    
    private func progressAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "In Progress") { (action, _, completion) in
            if indexPath.section == 0 {
                var movedItem = self.urgentTasks.remove(at: indexPath.row)
                movedItem.isUrgent = false
                movedItem.inProgress = true
                self.tasksInProgress.insert(movedItem, at: 0)
            } else if indexPath.section == 2 {
                var movedItem = self.doneTasks.remove(at: indexPath.row)
                movedItem.isDone = false
                movedItem.inProgress = true
                self.tasksInProgress.insert(movedItem, at: 0)
            }
            
            self.tableView.reloadData()
            //            StorageManager.shared.saveTask(with: [self.urgentTasks, self.tasksInProgress, self.doneTasks])
            StorageManager.shared.saveTaskToFile(with: [self.urgentTasks, self.tasksInProgress, self.doneTasks])
            completion(true)
        }
        
        action.backgroundColor = .systemYellow
        action.image = UIImage(systemName: "ellipses.bubble")
        return action
    }
    
}
