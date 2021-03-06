//
//  PostsViewController.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-27.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import RealmSwift

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var selectedClass : ClassForum!
    var openPosts : Results<Post>!
    var completedPosts : Results<Post>!
    var currentCreateAction:UIAlertAction!
    
    var isInEditMode = false
    

    @IBOutlet weak var postsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedClass.name
        readPostsAndUpdateUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        readPostsAndUpdateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readPostsAndUpdateUI() {
        completedPosts = self.selectedClass.posts.filter("isCompleted = true")
        openPosts = self.selectedClass.posts.filter("isCompleted = false")
        
        self.postsTableView.reloadData()
    }
    
    //MARK: - navbar buttons
    @IBAction func didClickOnEditPost(sender: AnyObject) {
        isInEditMode = !isInEditMode
        self.postsTableView.setEditing(isInEditMode, animated: true)
    }
    @IBAction func didClickOnAddPost(sender: AnyObject) {
        self.displayAlertToAddPost(nil)
    }
    
    //MARK: - required table functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openPosts.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "OPEN POSTS"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        var post: Post!
        post = openPosts[indexPath.row]
        
        cell?.textLabel?.text = post.name
        cell?.detailTextLabel?.text = "\(post.replyList.count) Replies"
        cell!.textLabel!.numberOfLines = 0;
        return cell!
    }
    
    //automatic resize of table cells
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: - alert for reply add/edit
    func displayAlertToAddPost(updatedPost:Post!) {
        var title = "New Post"
        var doneTitle = "Create"
        if updatedPost != nil {
            title = "Update Post"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Add a post:", preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            let postName = alertController.textFields?.first?.text
            
            do {
                
                if updatedPost != nil {
                    try uiRealm.write({ () -> Void in
                        updatedPost.name = postName!
                        self.readPostsAndUpdateUI()
                    })
                } else {
                    let newPost = Post()
                    newPost.name = postName!
                    
                    try uiRealm.write({ () -> Void in
                        self.selectedClass.posts.append(newPost)
                        self.readPostsAndUpdateUI()
                    })
                }
                
            } catch let error as NSError {
                
                print("FAILED TO ADD/UPDATE POST. \(error.localizedDescription)")
            }
            print(postName)

        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        //cancel
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            textField.placeholder = "Post"
            textField.addTarget(self, action: "postNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            if updatedPost != nil {
                textField.text = updatedPost.name
            }
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //creates a post only if there is something to post
    func postNameFieldDidChange(textField:UITextField) {
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //delete
            var postToBeDeleted: Post!
            postToBeDeleted = self.openPosts[indexPath.row]

            do {
                try uiRealm.write({() -> Void in
                uiRealm.delete(postToBeDeleted)
                self.readPostsAndUpdateUI()
                })
            } catch let error as NSError {
                
                print("FAILED TO DELETE POST. \(error.localizedDescription)")
            }
            
        }
        
        //edit
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
            var postToBeUpdated: Post!
            if indexPath.section == 0 {
                postToBeUpdated = self.openPosts[indexPath.row]
            } else {
                postToBeUpdated = self.completedPosts[indexPath.row]
            }
            
            self.displayAlertToAddPost(postToBeUpdated)
            
        }
        
        return [deleteAction, editAction]
    }
    
    
    // MARK: - Navigation
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("openPost", sender: self.openPosts[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let threadViewController = segue.destinationViewController as! ThreadViewController
        threadViewController.selectedPost = sender as! Post
    }
    

}
