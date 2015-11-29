//
//  ThreadViewController.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-27.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import RealmSwift
import Parse

class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    /*
    class Reply: Object {
    
    dynamic var replyId = 0
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var content = ""
    dynamic var postId = 0
    */
    
    var selectedPost : Post!
    var replies : Results<Reply>!
    var currentCreateAction:UIAlertAction!
    var isInEditMode = false
    
    //placeholder for current user data
    
    var userFirstName: String = ""
    var userSet: String = ""
    var userLastName: String = ""
    
    @IBOutlet weak var replyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        do{
            let user = try query!.findObjects().first as! PFUser
            userSet = user["set"] as! String
            userFirstName = user["firstName"] as! String
            userLastName = user["lastName"] as! String
        } catch{}
        
        
        self.title = selectedPost.name
        
        
        
        readRepliesAndUpdateUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readRepliesAndUpdateUI() {
        replies = self.selectedPost.replyList.sorted("createdAt")
        self.replyTableView.reloadData()
    }
    
    //MARK: - Table Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedPost.name
    }
    
    //automatic resize of table cells
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("replyCell")
        let replyList = replies[indexPath.row]
        
        //cell?.textLabel?.text = replyList.name
        var subtitle = "By: " + replyList.author + " at " + String(replyList.createdAt)
        cell?.textLabel?.text = replyList.name
        cell!.textLabel!.numberOfLines = 0;
        cell?.detailTextLabel?.text = subtitle
        
        
        return cell!
    }
    
    //make attributed string so table row will wrap content
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
//        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), NSForegroundColorAttributeName: UIColor.blackColor()]
        let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: nil)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        titleString.appendAttributedString(subtitleString)
        
        return titleString
    }
    
    //navbar buttons
    @IBAction func didClickOnEditReply(sender: AnyObject) {
        isInEditMode = !isInEditMode
        self.replyTableView.setEditing(isInEditMode, animated: true)
        readRepliesAndUpdateUI()
    }
    
    @IBAction func didClickOnAddReply(sender: AnyObject) {
        self.displayAlertToAddReply(nil)
    }
    
    
    //MARK: - manage table functions
    
    //TODO alert width?
    
    //add/edit reply alert
    func displayAlertToAddReply(updatedReply:Reply!) {
        var title = "New Reply"
        var doneTitle = "Add Post"
        if updatedReply != nil {
            title = "Edit Reply"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Enter your reply", preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            let replyName = alertController.textFields?.first?.text
            let replyAuthor = self.userFirstName + " " + self.userLastName
            let date = NSDate()
            //var date = NSCalendar.currentCalendar()
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            formatter.dateStyle = .MediumStyle
            let datestring = formatter.stringFromDate(date)
            
            
            do {
                //check if edit mode is set
                if updatedReply != nil {
                    try uiRealm.write({ () -> Void in
                        updatedReply.name = replyName!
                        self.readRepliesAndUpdateUI()
                    })
                } else {
                    //create new reply
                    let newReply = Reply()
                    newReply.name = replyName!
                    newReply.author = replyAuthor
                    newReply.createdAt = datestring
                    
                    try uiRealm.write({ () -> Void in
                        self.selectedPost.replyList.append(newReply)
                        self.readRepliesAndUpdateUI()
                    })
                }
                
            } catch let error as NSError {
                
                print("FAILED TO ADD/UPDATE REPLY. \(error.localizedDescription)")
            }
            print(replyName! + " by " + replyAuthor)
        }
        //create alert
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        //cancel button
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil ))
        
        //create textfield on alert
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Reply"
            textField.addTarget(self, action: "replyNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            if updatedReply != nil {
                textField.text = updatedReply.name
            }
        }
        //present alert
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //create reply only if the field has something in it
    func replyNameFieldDidChange(textField:UITextField) {
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    //update, delete
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        //DELETE
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            var replyToBeDeleted: Reply!
            replyToBeDeleted = self.replies[indexPath.row]
            
            do {
                try uiRealm.write({ () -> Void in
                    uiRealm.delete(replyToBeDeleted)
                    self.readRepliesAndUpdateUI()
                })
            } catch let error as NSError {
                
                print("FAILED TO DELETE REPLY. \(error.localizedDescription)")
            }
        }
        
        //UPDATE
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
            var replyToBeUpdated : Reply!
            replyToBeUpdated = self.replies[indexPath.row]
            self.displayAlertToAddReply(replyToBeUpdated)
        }

        return[deleteAction, editAction]
    }
    
}
