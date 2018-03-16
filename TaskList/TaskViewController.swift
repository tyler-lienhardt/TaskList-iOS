//
//  NewTaskViewController.swift
//  TaskList
//
//  Created by Wizard Needs Food on 3/13/18.
//  Copyright © 2018 Tyler Lienhardt. All rights reserved.
//

import UIKit
import os.log

class TaskViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var compSwitch: UISwitch!
    
    /*
        This value is either passed by 'TaskTableViewController' in 'prepare(for:sender)' or
        or constructed as part of adding a new task
    */
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        descTextField.delegate = self
        
        //set up views for an existing task
        if let task = task {
            navigationItem.title = task.name
            nameTextField.text = task.name
            descTextField.text = task.desc
            compSwitch.isOn = task.isCompleted
        }
        else {
            compSwitch.isOn = false
        }
        
        
        //Enable the Save button only if the text field has a valid Task name
        updateSaveButtonState()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TaskViewController is not inside a navigation controller")
        }
        
    }
    
    //preparing to save the new task
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let nameString = nameTextField.text ?? ""
        let descString = descTextField.text ?? ""
        
        let isCompleted = compSwitch.isOn
        
        //if editing an exisiting task, do not update the date
        if task != nil {
            let date = task!.date
            task = Task(name: nameString, desc: descString, date: date, isCompleted: isCompleted)
        }
        else {
            task = Task(name: nameString, desc: descString, date: Date(), isCompleted: isCompleted)
        }
    }
    
    // MARK: Private methods
    
    private func updateSaveButtonState() {
        
        //Disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
