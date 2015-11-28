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

class SignUpInViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    
    @IBAction func signUp(sender: AnyObject) {
        self.performSegueWithIdentifier("signUpSegue", sender: self)    }

    @IBAction func signIn(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var uName = userName.text
        //  var userSet = set.text
        
        uName = uName!.uppercaseString
        //  userSet = userSet!.uppercaseString
        
        var userPassword = password.text
        
        PFUser.logInWithUsernameInBackground(uName!, password:userPassword!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
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
        self.password.delegate = self;
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //check if user logged in, and show their schedule if they are
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("signInToNavigation", sender: self)
        }
        
    }

    
}

