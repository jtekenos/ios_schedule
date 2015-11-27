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
 

    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

