//
//  addEventViewController.swift
//  ios_schedule
//
//  Created by Denis Turitsa on 2015-11-29.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import Parse

class addEventViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var setLabel: UITextField!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        setLabel.text = ""
        descriptionLabel.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func addButton(sender: AnyObject) {
        
        var name: String = nameLabel.text!
        var eventDescription: String = descriptionLabel.text!
        var eventSet: String = setLabel.text!.uppercaseString
        var date: NSDate = datePicker.date
        var repeatEvent: Bool = repeatSwitch.on
        var dayformatter = NSDateFormatter()
        dayformatter.dateFormat = "EEEE"
        let dayOfweek: String = dayformatter.stringFromDate(date)
        
  
        var scheduleEvent = PFObject(className:"Schedule")
        scheduleEvent["date"] = date
        scheduleEvent["eventName"] = name
        scheduleEvent["classSet"] = eventSet
        scheduleEvent["eventDescription"] = eventDescription
        scheduleEvent["dayOfweek"] = dayOfweek
        scheduleEvent["eventRepeat"] = repeatEvent
        scheduleEvent["redFlag"] = false

        let alert = UIAlertView()
        
        alert.message = ""
        alert.addButtonWithTitle("OK")
        
        scheduleEvent.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                alert.title = "Event Added"
                
            } else {
                alert.title = "Error"
            }
            alert.show()
        }
        
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
