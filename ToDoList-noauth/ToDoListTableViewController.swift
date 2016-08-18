//
//  ToDoListTableViewController.swift
//  ToDoList-noauth
//
//  Created by ykro on 8/18/16.
//  Copyright © 2016 Bit & Ik'. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    var todoItems: [ToDoItem] = [
        ToDoItem(item: "Go to the dentist", username: "asdf"),
        ToDoItem(item: "Fetch groceries", username: "asdf"),
        ToDoItem(item: "Sleep", username: "asdf")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
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
        
        let tappedItem = todoItems[indexPath.row] as ToDoItem
        tappedItem.completed = !tappedItem.completed
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            todoItems.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindAndAddToList(segue: UIStoryboardSegue) {
        let source = segue.sourceViewController as! AddToDoItemViewController
        let toDoItem:ToDoItem = source.toDoItem
        
        if toDoItem.item != "" {
            self.todoItems.append(toDoItem)
            self.tableView.reloadData()
        }
    }

}
