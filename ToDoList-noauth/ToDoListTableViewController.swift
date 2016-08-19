//
//  ToDoListTableViewController.swift
//  ToDoList-noauth
//
//  Created by ykro on 8/18/16.
//  Copyright © 2016 Bit & Ik'. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ToDoListTableViewController: UITableViewController {
    private let ITEMS_CHILD_NAME: String = "items";
    var databaseReference: FIRDatabaseReference = FIRDatabaseReference()
    
    var todoItems: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseReference = FIRDatabase.database().reference().child(ITEMS_CHILD_NAME)
        navigationItem.leftBarButtonItem = editButtonItem()
        
        databaseReference.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot: FIRDataSnapshot) in
            let item: ToDoItem = ToDoItem(snapshot: snapshot)!
            
            if (!self.todoItems.contains({$0.id == item.id})) {
                self.todoItems.append(item)
                self.tableView.reloadData()
            }            
        })
        
        databaseReference.observeEventType(FIRDataEventType.ChildChanged, withBlock: { (snapshot: FIRDataSnapshot) in
            let item: ToDoItem = ToDoItem(snapshot: snapshot)!
            let index: Int = self.todoItems.indexOf({$0.id == item.id})!
            
            
            self.todoItems[index] = item
            self.tableView.reloadData()
        })
        
        databaseReference.observeEventType(FIRDataEventType.ChildRemoved, withBlock: { (snapshot: FIRDataSnapshot) in
            let item: ToDoItem = ToDoItem(snapshot: snapshot)!
            let index = self.todoItems.indexOf({$0.id == item.id})
            if (index != nil) {
                self.todoItems.removeAtIndex(index!)
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        let item = todoItems[indexPath.row]

        if (item.completed) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None;
        }
        
        cell.textLabel?.text = item.item
        cell.detailTextLabel?.text = item.username
        cell.textLabel
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var tappedItem = todoItems[indexPath.row] as ToDoItem
        tappedItem.completed = !tappedItem.completed
        todoItems[indexPath.row] = tappedItem
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)

        databaseReference.child(tappedItem.id).updateChildValues(tappedItem.dictionary)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let selectedItem = todoItems[indexPath.row] as ToDoItem
            databaseReference.child(selectedItem.id).removeValue()
            
            todoItems.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindAndAddToList(segue: UIStoryboardSegue) {
        let source = segue.sourceViewController as! AddToDoItemViewController
        var toDoItem:ToDoItem = source.toDoItem
        
        if toDoItem.item != "" {
            
            let newElementReference = databaseReference.childByAutoId()
            newElementReference.setValue(toDoItem.dictionary)
            toDoItem.id = newElementReference.key
            
            todoItems.append(toDoItem)
            tableView.reloadData()
        }
    }

}
