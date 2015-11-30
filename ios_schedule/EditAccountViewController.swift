//
//  EditAccountViewController.swift
//  ios_schedule
//
//  Created by Denis Turitsa on 2015-11-27.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import Parse

class EditAccountViewController: UIViewController, UITextFieldDelegate {
    var userId: String = ""
    var userEmail: String = ""
    var userFirstName: String = ""
    var userLastName: String = ""
    var userSet: String = ""
    
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var set: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var message: UILabel!
    
    @IBAction func editButton(sender: AnyObject) {
        if let currentUser = PFUser.currentUser()
        {
            currentUser.email = email.text
            currentUser["set"] = set.text
            currentUser["firstName"] = firstName.text
            currentUser["lastName"] = lastName.text
            currentUser.saveInBackgroundWithBlock{
                (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    
                    //edit confirmation alert
                    let alert = UIAlertView()
                    alert.title = "Account Updated"
                    alert.message = "Please sign out for changes to take effect"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    
                } else {
                    
                    if let message: AnyObject = error!.userInfo["error"] {
                        self.message.text = "\(message)"
                        
                    }
                }
            }
        }
        
    }
    
    @IBAction func logoutAction(sender: AnyObject)
    {
        PFUser.logOut()
        self.performSegueWithIdentifier("editToLoginSegue", sender: self)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get user info
        let query = PFUser.query()
        query!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        do{
            var user = try query!.findObjects().first as! PFUser
            userSet = user["set"] as! String
            userFirstName = user["firstName"] as! String
            userLastName = user["lastName"] as! String
            userId = (PFUser.currentUser()!.username)!
            userEmail = (PFUser.currentUser()!.email)!
        } catch{}
        
        studentID.text = userId
        firstName.text = userFirstName
        lastName.text = userLastName
        set.text = userSet
        email.text = userEmail
        message.text = ""
        
        self.firstName.delegate = self;
        self.lastName.delegate = self;
        self.email.delegate = self;
        self.set.delegate = self;
    }
    /*
    @IBAction func toScheduleBut(sender: AnyObject) {
    self.performSegueWithIdentifier("editToTabBarSegue", sender: self)
    
    }
    
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
