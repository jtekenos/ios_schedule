//
//  ClassListViewController.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-27.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import RealmSwift

class ClassListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var classes : Results<ClassForum>!
    var isInEditMode = false
    var currentCreateAction:UIAlertAction!
    
    /*
    let pages = [
    PageOption(displayName: "Google", url: "https://google.com"),
    PageOption(displayName: "Apple", url: "https://apple.com"),
    PageOption(displayName: "iOS Developer Library", url: "https://developer.apple.com/library/ios/navigation/"),
    PageOption(displayName: "Twitter", url: "https://twitter.com"),
    PageOption(displayName: "BCIT", url: "https://learn.bcit.ca")
    ]
    
    dynamic var classForumId = 0
    dynamic var name = ""
    dynamic var instructor = ""
    let posts = List<Post>()
    
    */
    
    
    @IBOutlet weak var classListTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        readClassesAndUpdateUI()
    }
    
    //get list of current classes
    func readClassesAndUpdateUI() {
        
        classes = uiRealm.objects(ClassForum)
        self.classListTableView.setEditing(false, animated: true)
        self.classListTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //edit button
    @IBAction func didClickOnEditButton(sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        self.classListTableView.setEditing(isInEditMode, animated: true)
    }
    
    //add button
    @IBAction func didClickOnAddButton(sender: UIBarButtonItem) {
        
        displayAlertToAddClassForum(nil)
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    func classNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    func displayAlertToAddClassForum(updatedClass:ClassForum!) {
        var title = "New Class Forum"
        var doneTitle = "Create"
        
        if updatedClass != nil {
            title = "Update Class Forum"
            doneTitle = "Update"
        }
        
        let alertController =
            UIAlertController(title: title, message: "Enter the name of the class", preferredStyle: UIAlertControllerStyle.Alert)
        
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default){ (action) -> Void in
            
            let className = alertController.textFields?.first?.text
            
            //add-update try
            do {
                
                if updatedClass != nil {
                    try uiRealm.write({ () -> Void in updatedClass.name = className!
                        self.readClassesAndUpdateUI()
                    })
                } else {
                    let newClassForum = ClassForum()
                    newClassForum.name = className!
                    
                    try uiRealm.write({ () -> Void in
                        
                        uiRealm.add(newClassForum)
                        self.readClassesAndUpdateUI()
                    })
                    
                }
                
                
            } catch let error as NSError {
                
                print("FAILED TO ADD/UPDATE. \(error.localizedDescription)")
            }
            //add-update end
            
            print(className)
        }
        
        //set alert for current add/edit
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        //cancel add
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        //alert title
        alertController.addTextFieldWithConfigurationHandler{(textfield) -> Void in
            textfield.placeholder = "Class Forum Name"
            textfield.addTarget(self, action: "classNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            if updatedClass != nil {
                textfield.text = updatedClass.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listClasses = classes{
            return listClasses.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCellWithIdentifier("classCell")
        let classList = classes[indexPath.row]
        
        cell?.textLabel?.text = classList.name
        cell?.detailTextLabel?.text = "\(classList.posts.count) Posts"
        return cell!
    }
    
    
    //Edit and delete functions
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //TODO delete
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            let classToBeDeleted = self.classes[indexPath.row]
            
            do {
                try uiRealm.write( { () -> Void in uiRealm.delete(classToBeDeleted)
                    self.readClassesAndUpdateUI()
                })
                
            } catch let error as NSError {
                
                print("FAILED TO ADD/UPDATE. \(error.localizedDescription)")
            }
            
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") {(editAction, indexPath) -> Void in
        
            let classToBeUpdated = self.classes[indexPath.row]
            self.displayAlertToAddClassForum(classToBeUpdated)
        }
        return [deleteAction, editAction]
        
    }
    
    // MARK: - Navigation
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("openClass", sender: self.classes[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let postsViewController = segue.destinationViewController as! PostsViewController
        postsViewController.selectedClass = sender as! ClassForum
    }
    
    

}
