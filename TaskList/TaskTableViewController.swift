//
//  TaskTableViewController.swift
//  TaskList
//
//  Created by Wizard Needs Food on 3/12/18.
//  Copyright © 2018 Tyler Lienhardt. All rights reserved.
//

import UIKit
import os.log

class TaskTableViewController: UITableViewController {
    
    //MARK: Properties
        
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleTasks()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TaskTableViewCell"
        
        //Table view cells are reused and should be dequeued using a cell identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("The dequeued cell is not an instance of TaskTableViewCell")
        }
        
        let task = tasks[indexPath.row]
        
        cell.nameLabel.text = task.name
        
        //completed tasks have a gray background
        if task.isCompleted == true {
            cell.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
        }
        else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    //swipe left reveals the complete button
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]
        
        let compAction = UIContextualAction(style: .normal, title: "Complete") { (action, view, handler) in
            
            if task.isCompleted == false {
                task.isCompleted = true
            }
            else {
                task.isCompleted = false
            }
            
            self.tasks.sort()
            tableView.reloadData()
        }
        
        compAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [compAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    //swipe right reveals the delete button
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            
            self.tasks.remove(at: indexPath.row)
            
            self.tasks.sort()
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new task.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let taskDetailViewController = segue.destination as? TaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTaskCell = sender as? TaskTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTask = tasks[indexPath.row]
            taskDetailViewController.task = selectedTask
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing task
                tasks[selectedIndexPath.row] = task
                
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                tasks.sort()
                tableView.reloadData()
            }
            else {
            
                //adding the new task to tasks and updating the table view
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                tasks.sort()
                tableView.reloadData()
            }
        }
    }
    
    //MARK: Private methods
    
    private func loadSampleTasks() {
        
        guard let task1 = Task(name: "Make sandwich", desc: "pbj everyday", date: Date(), isCompleted: false) else {
            fatalError("Unable to instantiate task3")
        }
        
        guard let task2 = Task(name: "Get bread", desc: "Delicious bread", date: Date(), isCompleted: false) else {
            fatalError("Unable to instantiate task1")
        }
        
        guard let task3 = Task(name: "Get peanut butter", desc: "extra chunky", date: Date(), isCompleted: false) else {
            fatalError("Unable to instantiate task2")
        }
        
        guard let task4 = Task(name: "Get jelly", desc: "raspberry", date: Date(), isCompleted: false) else {
            fatalError("Unable to instantiate task3")
        }
        

        
        tasks += [task1, task2, task3, task4]
        tasks.sort()
        
    }

}
