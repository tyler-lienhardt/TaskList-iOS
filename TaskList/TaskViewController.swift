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
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /*
        This value is either passed by 'TaskTableViewController' in 'prepare(for:sender)' or
        constructed as part of adding a new task
    */
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        descTextField.delegate = self
        
        //preparing the date to display
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        
        //set up views for an existing task
        if let task = task {
            navigationItem.title = task.name
            nameTextField.text = task.name
            descTextField.text = task.desc
            datePicker.date = task.date
            completedSwitch.isOn = task.isCompleted
            dateLabel.text = dateFormatter.string(from: task.date)
        }
        else {
            completedSwitch.isOn = false
        }
        
        //Enable the Save button only if the text field has a valid Task name
        updateSaveButtonState()
        
        //Notification observers to keep text views visible when keyboard appears
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(TaskViewController.keyboardWillShow(_:)),
            name: Notification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(TaskViewController.keyboardWillHide(_:)),
            name: Notification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1: -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
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
        let date = datePicker.date
        
        let isCompleted = completedSwitch.isOn
        
        //if editing an exisiting task, do not update the date
        if task != nil {
            task = Task(name: nameString, desc: descString, date: date, isCompleted: isCompleted)
        }
        else {
            task = Task(name: nameString, desc: descString, date: date, isCompleted: isCompleted)
        }
    }
    
    // MARK: Private methods
    
    private func updateSaveButtonState() {
        
        //Disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
