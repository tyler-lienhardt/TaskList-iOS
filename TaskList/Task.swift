//
//  Task.swift
//  TaskList
//
//  Created by Wizard Needs Food on 3/10/18.
//  Copyright © 2018 Tyler Lienhardt. All rights reserved.
//

import UIKit

class Task {
    
    //MARK Properties
    
    var name: String
    var desc: String
    var isCompleted: Bool = false
    var date: Date
    
    init? (name: String, desc: String, date: Date, isCompleted: Bool) {
        
        //init should fail if there is no name provided
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.desc = desc
        self.date = date
        self.isCompleted = isCompleted
    }
}

extension Task : Comparable {
    static func < (lhs: Task, rhs: Task) -> Bool {
        //to sort dates by newest first
        if (lhs.isCompleted == false && rhs.isCompleted == false) {
            return !(lhs.date < rhs.date)
        }
        else if (lhs.isCompleted == true && rhs.isCompleted == false){
            return false
        }
        else if (lhs.isCompleted == false && rhs.isCompleted == true) {
            return true
        }
        else {
            return !(lhs.date < rhs.date)
        }
    }

    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.date == rhs.date
    }
}
