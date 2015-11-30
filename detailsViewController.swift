//
//  detailsViewController.swift
//  ios_schedule
//
//  Created by Denis Turitsa on 2015-11-29.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import Parse

class detailsViewController: UIViewController {
    var id: String = ""
    var pulledEvent: PFObject!
    
    
    @IBAction func deleteButton(sender: AnyObject) {
        pulledEvent.deleteInBackground()
         self.performSegueWithIdentifier("detailsToSchedule", sender: self)
        
    }
    
    @IBOutlet weak var deleteButOutlet: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSettings()
        getEvent()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEvent(){
        
        var query = PFQuery(className:"Schedule")
        query.whereKey("objectId", equalTo: id)
        do{
            pulledEvent = try query.findObjects().first as PFObject!
            titleLabel.text = pulledEvent["eventName"] as! String
            setLabel.text = "Set: " + (pulledEvent["classSet"] as! String)
            detailsLabel.text = pulledEvent["eventDescription"] as! String
            
            let date = pulledEvent["date"] as! NSDate
            let f = NSDateFormatter()
            f.dateFormat = "HH:mm EEEE MMMM dd yyyy"
            dateLabel.text = f.stringFromDate(date)
            
            
            
            
            
        } catch{}
    }

    func userSettings(){
        var userquery = PFUser.query()
        userquery!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        do{
            var user = try userquery!.findObjects().first as! PFUser
            let userRole = user["role"] as! String
            if(userRole == "admin"){
                self.deleteButOutlet.hidden = false
   
            } else{
                 //self.deleteButOutlet.hidden = true
            }
        } catch{}
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}
