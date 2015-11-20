//
//  ForumTableViewController.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-19.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit

struct ForumPage {
    let forumName: String
    let instructor: String
    let location: String
}


class ForumTableViewController: UITableViewController {
    
    let subForums = [
        ForumPage(forumName: "COMP4977 - iOS", instructor: "Darcy Smith", location: ""),
        ForumPage(forumName: "COMP4711 - Software Dev", instructor: "Jim Parry", location: ""),
        ForumPage(forumName: "COMP4976 - ASP.NET", instructor: "Medhat Elmasry", location: ""),
        ForumPage(forumName: "COMP4560 - Graphics", instructor: "Brenda Fine", location: ""),
        ForumPage(forumName: "BLAW3600 - Law", instructor: "Catherine Ryan", location: ""),
        ForumPage(forumName: "COMP4735 - Operating Systems", instructor: "Mirela Gutica", location: "")
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subForums.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ForumCell", forIndexPath: indexPath)

        let forumPage = subForums[indexPath.row]
        cell.textLabel?.text = forumPage.forumName

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToForum" {
            var forumViewController: ForumViewController!
            if let forumTableViewController = segue.destinationViewController as? UINavigationController {
                forumViewController = forumTableViewController.topViewController as! ForumViewController
            } else {
                forumViewController = segue.destinationViewController as! ForumViewController
            }
            if let selectedForum = tableView.indexPathForSelectedRow {
                let forumOption = subForums[selectedForum.row]
                forumViewController.forumPage = forumOption
            }
        }
        
    }
    

}
