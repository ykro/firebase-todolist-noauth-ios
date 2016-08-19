//
//  ToDoItem.swift
//  ToDoList-noauth
//
//  Created by ykro on 8/18/16.
//  Copyright © 2016 Bit & Ik'. All rights reserved.
//

import Foundation
import Firebase

struct ToDoItem {
    var id: String = ""
    
    var item: String
    var username: String
    var completed: Bool    
        
    var dictionary: [String: AnyObject] {
        return [
            "item" : self.item,
            "username": self.username,
            "completed": self.completed
        ]
    }
    
    init(item: String, username: String) {
        self.item = item
        self.username = username
        self.completed = false
    }
    
    init() {
        self.init(item: "", username:  "")
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        guard let item = dict["item"] else { return nil }
        guard let username  = dict["username"]  else { return nil }
        guard let completed = dict["completed"] else { return nil }
        
        self.id = snapshot.key
        self.item = item as! String
        self.username = username as! String
        self.completed = completed as! Bool
    }
}