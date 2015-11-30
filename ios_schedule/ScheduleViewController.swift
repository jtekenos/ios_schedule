//
//  ScheduleViewController.swift
//  ios_schedule
//
//  Created by Denis Turitsa on 2015-11-28.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import Parse

class ScheduleViewController: UIViewController {
    var eventList : [PFObject] = []
    var scheduleDate = NSDate()
    var currentUserSet:String = ""
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var setText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
 
    @IBOutlet weak var addEventButton: UIButton!

    @IBAction func getScheduleButton(sender: AnyObject) {
        scheduleDate = datePicker.date
        getSchedule()
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.eventList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        let event = self.eventList[indexPath.row]
        let eventDate : NSDate = event["date"] as! NSDate
        let eventTitle : String = event["eventName"] as! String
        let redFlag : Bool = event["redFlag"] as! Bool
        var time = NSDateFormatter()
        time.dateFormat = "HH:mm"

      cell.timeLabel.text = time.stringFromDate(eventDate)
        
        cell.detailsButton.tag = indexPath.row;
        cell.detailsButton.addTarget(self, action: "detailsAction:", forControlEvents: .TouchUpInside)
        
        if(redFlag){
            cell.titlleLabel.textColor = UIColor.redColor()
            cell.titlleLabel.text = eventTitle + " - CANCELLED"
            cell.timeLabel.textColor = UIColor.redColor()
        } else{
            cell.titlleLabel.text = eventTitle
        }
        
  
        return cell
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "detailsSegue") {
            let secondViewController = segue.destinationViewController as! detailsViewController
            let id = sender as! String
            secondViewController.id = id
        }
    }
    
    @IBAction func detailsAction(sender: UIButton) {
        
        let currentObject: PFObject = self.eventList[sender.tag]
        let id: String = currentObject.objectId!
        
        self.performSegueWithIdentifier("detailsSegue", sender: id)
        
    }

    func getSchedule(){
        self.eventList = []
        var dayformatter = NSDateFormatter()
        dayformatter.dateFormat = "EEEE"
        let dayOfweek: String = dayformatter.stringFromDate(scheduleDate)
        
        currentUserSet = self.setText.text!.uppercaseString

        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let startOfday = cal!.startOfDayForDate(scheduleDate)
        let endOfDay = cal!.startOfDayForDate(scheduleDate.dateByAddingTimeInterval(60*60*24))
        
        print(dayformatter.stringFromDate(startOfday))
        print(dayformatter.stringFromDate(endOfDay))

        var query1 = PFQuery(className:"Schedule")
        query1.whereKey("classSet", equalTo: currentUserSet)
        query1.whereKey("date", greaterThanOrEqualTo: startOfday)
        query1.whereKey("date", lessThanOrEqualTo: endOfDay)
        query1.whereKey("eventRepeat", equalTo: false)
        do{
            self.eventList += try query1.findObjects()
            
        } catch{}

        var query = PFQuery(className:"Schedule")
        query.whereKey("dayOfweek", equalTo: dayOfweek)
        query.whereKey("classSet", equalTo: currentUserSet)
        query.whereKey("eventRepeat", equalTo: true)

        do{
            self.eventList += try query.findObjects()
            
        } catch{}
        
        let hour = NSDateFormatter()
        hour.dateFormat = "HH"
        self.eventList.sortInPlace({Int(hour.stringFromDate($0["date"] as! NSDate)) < Int(hour.stringFromDate($1["date"] as! NSDate)) })
        self.tableView.reloadData()
        
        
    }

    func userSettings(){
        var userquery = PFUser.query()
        userquery!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        do{
            var user = try userquery!.findObjects().first as! PFUser
            currentUserSet = user["set"] as! String
            self.setText.text = currentUserSet
            let userRole = user["role"] as! String
            if(userRole == "admin"){
                self.addEventButton.hidden = false
                self.setText.hidden = false
            } else{
                //self.addEventButton.hidden = true
                //self.setText.hidden = true
            }
        } catch{}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSettings()
        getSchedule()
        self.title = "Schedule"
        
        
       
        
        
        
        
/*
        var scheduleEvent = PFObject(className:"Schedule")
        scheduleEvent["date"] = NSDate()
        scheduleEvent["eventName"] = "COMP1111"
        scheduleEvent["eventDescription"] = "test description"
        scheduleEvent["dayOfweek"] = "Thursday"
        scheduleEvent["eventRepeat"] = false
        scheduleEvent.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("saved")
            } else {
                print("error saving")
            }
        }
*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}

    class ScheduleEvent : PFObject {
        var date = NSDate()
        var eventName = ""
        var eventRepeat = false
        var eventDescription = ""
        var dayOfWeek = ""
        
        
}
