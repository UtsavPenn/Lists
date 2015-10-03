//
//  ViewController.swift
//  Lists
//
//  Created by Utsav Mehta on 8/31/15.
//  Copyright (c) 2015 Utsav Mehta. All rights reserved.
//

import UIKit
import CloudKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,TableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems = [ToDoItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.rowHeight = 50.0
        tableView.backgroundColor = UIColor.whiteColor()
        
        if toDoItems.count > 0 {
            return
        }
        //self.saveRecord("Complete Office Work")
        self.getData()

        }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell",
                forIndexPath: indexPath) as! TableViewCell
            cell.selectionStyle = .None
            let item = toDoItems[indexPath.row]
            //cell.textLabel?.backgroundColor = UIColor.clearColor()
            //cell.textLabel?.text = item.text
            cell.delegate = self
            cell.toDoItem = item
            
            return cell
    }

    // MARK: - Table view delegate
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    
    func toDoItemDeleted(toDoItem: ToDoItem) {
        let index = (toDoItems as NSArray).indexOfObject(toDoItem)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        toDoItems.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()    
    }
   
    

    func getData() {
        print("Inside Get Data")
        let container = CKContainer.defaultContainer()
        let privateDB = container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Todos", predicate: predicate)
        privateDB.performQuery(query,inZoneWithID: nil){(results, error) in
            if error != nil{
                dispatch_async(dispatch_get_main_queue()) {
                    NSLog("Error retrieving data from iCloud : \(error!.userInfo)")
                    print("INSIDE IF")
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    NSLog("Successfully retrieved data")
                    if results!.count>0{
                        var result: CKRecord
                        var todoItem: ToDoItem
                        for result in results!{
                            let doText = result.objectForKey("todotext") as! String
                            todoItem = ToDoItem(text: "\(doText)")
                            print("Retrieved value: \(todoItem.text)")
                            self.toDoItems.append(todoItem)
                            print("Count: \(self.toDoItems.count)")
                            
                        }
                        self.tableView.reloadData()
                    }
                    print("INSIDE ELSE")
                }
            }
        }
        print("Count outside \(self.toDoItems.count)")
    }
    
    
    @IBAction func unwindtoToDoList(sender: UIStoryboardSegue) {
        
    }

    
}

    

    
    
    

