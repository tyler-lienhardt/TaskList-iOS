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
    
    init? (name: String, desc: String, date: Date) {
        
        //init should fail if there is no name provided
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.desc = desc
        self.date = date
    }
}
