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
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
            }
            else {
            
                //adding the new task to tasks and updating the table view
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            }
        }
    }
    
    //MARK: Private methods
    
    private func loadSampleTasks() {
        guard let task1 = Task(name: "Get bread", desc: "Delicious bread", date: Date()) else {
            fatalError("Unable to instantiate task1")
        }
        
        guard let task2 = Task(name: "Get peanut butter", desc: "extra chunky", date: Date()) else {
            fatalError("Unable to instantiate task2")
        }
        
        guard let task3 = Task(name: "Get jelly", desc: "raspberry", date: Date()) else {
            fatalError("Unable to instantiate task3")
        }
        
        tasks += [task1, task2, task3]
        
    }

}
