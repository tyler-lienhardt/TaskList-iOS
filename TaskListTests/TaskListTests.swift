//
//  TaskListTests.swift
//  TaskListTests
//
//  Created by Wizard Needs Food on 2/26/18.
//  Copyright © 2018 Tyler Lienhardt. All rights reserved.
//

import XCTest
@testable import TaskList

class TaskListTests: XCTestCase {
    
    //MARK: Task Class Tests
    
    //Confirm that the Task initializer returns a Task object when passed valid parameters.
    func testTaskInitializationSucceeds() {
        
        //valid name, desc, and date
        let taskValid = Task.init(name: "Test Task", desc: "Test Description", date: Date())
        XCTAssertNotNil(taskValid)
    }
    
    //Confirm the Task initializer returns nil when passed an empty name
    func testTaskInitilizationFails() {
        
        //invalid task (empty name)
        let taskInvalid = Task.init(name: "", desc: "test description", date: Date())
        XCTAssertNil(taskInvalid)
    }
    
}
