//
//  ToDoItem.swift
//  ToDoList-noauth
//
//  Created by ykro on 8/18/16.
//  Copyright © 2016 Bit & Ik'. All rights reserved.
//

import Foundation

class ToDoItem: NSObject {
    var item: String
    var username: String
    var completed: Bool    
    
    init(item: String, username: String) {
        self.item = item
        self.username = username
        self.completed = false
    }
}