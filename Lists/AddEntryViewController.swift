//
//  AddEntryViewController.swift
//  Lists
//
//  Created by Utsav Mehta on 9/26/15.
//  Copyright © 2015 Utsav Mehta. All rights reserved.
//

import UIKit
import CloudKit

class AddEntryViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var ToDoItemDesc: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Handle the text field’s user input through delegate callbacks
        ToDoItemDesc.delegate  =  self
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidToDoItemName()
    }
   
    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    func saveRecord(todo : NSString) {
        let alert = UIAlertView()
        let container = CKContainer.defaultContainer()
        let privateDB = container.privateCloudDatabase
        let todoRecord = CKRecord(recordType: "Todos")
        todoRecord.setValue(todo, forKey: "todotext")
        privateDB.saveRecord(todoRecord, completionHandler:{(record,error) in
            if error != nil {
                NSLog("Error saving record:\(error)")
                alert.title = "Adding new To Do Item.."
                alert.message = "Error saving new To Do Item"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
            else {
                NSLog("Successfully saved record!")
                alert.title = "Adding new To Do Item.."
                alert.message = "Successfully saved new To Do Item.. :)"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
            }
        })
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidToDoItemName()
        navigationItem.title = ToDoItemDesc.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    // Disable the Save button while editing.
    saveButton.enabled = false
    }
    
    func checkValidToDoItemName() {
        // Disable the Save button if the text field is empty.
        let text = ToDoItemDesc.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let todoItemAdded = ToDoItemDesc.text
        self.saveRecord(todoItemAdded!)
        
        }
        
    
}
