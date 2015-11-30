//
//  SignUpInViewController.swift
//  ios_schedule
//
//  Created by Denis Turitsa on 2015-11-26.
//  Copyright © 2015 Jess. All rights reserved.
//

import Parse
import ParseUI

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var set: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    @IBAction func signUp(sender: AnyObject) {
        
        // Build the terms and conditions alert
        let alertController = UIAlertController(title: "Agree to terms and conditions",
            message: "BCIT iAgenda is not responsible for any missed classes",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "I AGREE",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.processSignUp()})
        )
        alertController.addAction(UIAlertAction(title: "I do NOT agree",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        
        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func processSignUp() {
        
        var uName = userName.text
        var userSet = set.text
        let userPassword = password.text
        let userFirstName = firstName.text
        let userLatName = lastName.text
        let userEmail = email.text
        
        
        // Ensure username is lowercase
        uName = uName!.uppercaseString
        userSet = userSet!.uppercaseString
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // Create the user
        var user = PFUser()
        user.username = uName
        user.password = userPassword
        user.email = userEmail
        user["set"] = userSet
        user["firstName"] = userFirstName
        user["lastName"] = userLatName
        user["role"] = "student"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("signUptoTabBarSegue", sender: self)
                }
                
            } else {
                
                self.activityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo["error"] {
                    self.message.text = "\(message)"
                }
            }
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = ""
        self.userName.delegate = self;
        self.firstName.delegate = self;
        self.lastName.delegate = self;
        self.password.delegate = self;
        self.email.delegate = self;
        self.set.delegate = self;
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
}

