//
//  CloudKitHelper.swift
//  Lists
//
//  Created by Utsav Mehta on 8/31/15.
//  Copyright (c) 2015 Utsav Mehta. All rights reserved.
//



import Foundation
import CloudKit

protocol CloudKitDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}


class CloudKitHelper {
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    
    var currentRecord: CKRecord?
    var todoText: NSString
    var toDoItems = [ToDoItem]()
        init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        self.todoText = ""
        self.currentRecord = nil
            
    }
    
    func saveRecord(todo : NSString) {
        let todoRecord = CKRecord(recordType: "Todos")
        todoRecord.setValue(todo, forKey: "todotext")
        privateDB.saveRecord(todoRecord, completionHandler:{(record,error) in
            if error != nil {
            NSLog("Error saving record:\(error)")
            }
            else {
            NSLog("Successfully saved record!")
            }
        })
    }
    
    
    func getData() {
        print("Inside Get Data")
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
                        }
                    print("INSIDE ELSE")
                    }
                }
            }
         print("Count outside \(self.toDoItems.count)")
        }
    }
    

    
    
    
    

