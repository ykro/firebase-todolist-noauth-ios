//
//  ViewController.swift
//  ToDoList-noauth
//
//  Created by ykro on 8/18/16.
//  Copyright © 2016 Bit & Ik'. All rights reserved.
//

import UIKit

class AddToDoItemViewController: UIViewController {
    var toDoItem: ToDoItem = ToDoItem()
    
    @IBOutlet weak var txtNewItem: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUsername()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (txtNewItem.text != "") {
            toDoItem.item = txtNewItem.text!
            let preferences = NSUserDefaults.standardUserDefaults()
            let usernameKey = "username"
            toDoItem.username = preferences.stringForKey(usernameKey)!
        }
    }
    
    func setupUsername() {
        let preferences = NSUserDefaults.standardUserDefaults()
        let usernameKey = "username"
        let randomNumber: Int = Int(arc4random_uniform(100000))
        let username = "iOSUser \(randomNumber)"
        if preferences.objectForKey(usernameKey) == nil {
            preferences.setObject(username , forKey: usernameKey)
            preferences.synchronize()
        }
    }
}

