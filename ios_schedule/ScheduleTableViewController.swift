//
//  ScheduleTableViewController.swift
//  Valio
//
//  Created by Sam Soffes on 6/5/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Alamofire
import UIKit


class ScheduleTableViewController: UITableViewController {
   lazy var scheduleData: NSArray = []

	

    //📅
	
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /*
        //load from local json file
        self.scheduleData = {
            let path = NSBundle.mainBundle().pathForResource("testData", ofType: "json")!
            let data = try! NSData(contentsOfFile: path, options: [])
            return (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! NSArray
            }()
        */

        //alamofire load mongolab json files
        Alamofire.request(.GET, "https://api.mongolab.com/api/1/databases/quizaerotest/collections/iOSSchedule?apiKey=Ce20LdOG8wMtypYyzXTk6wkkQUo-TVUf")
            .responseJSON { response in
                self.scheduleData = (try! NSJSONSerialization.JSONObjectWithData(response.data!, options: [])) as! NSArray
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
        }
        //end load json
        
		//navigationItem.titleView = UIImageView(image: UIImage(named: "Valio"))
		tableView.registerClass(ItemTableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.separatorStyle = .None
    }
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return scheduleData.count
	}

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
		let day = scheduleData[section] as! NSDictionary
		let items = day["items"] as! NSArray
		return items.count
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ItemTableViewCell
		let day = scheduleData[indexPath.section] as! NSDictionary
		let items = day["items"] as! NSArray
		let item = items[indexPath.row] as! NSDictionary
		
		cell.titleLabel.text = item["title"] as? String
		cell.timeLabel.text = item["time"] as? String
		
		if let minor = item["minor"] as? Bool {
			cell.minor = minor
		} else {
			cell.minor = false
		}

		return cell
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let day = scheduleData[section] as! NSDictionary
        //print(scheduleData[0]);
       

		return day["title"] as? String
	}
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let day = scheduleData[section] as! NSDictionary
		let view = SectionHeaderView()
		view.titleLabel.text = (day["title"] as! String).uppercaseString
		return view
	}
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 45
	}
}
