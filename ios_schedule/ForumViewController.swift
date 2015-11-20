//
//  ForumViewController.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-19.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit

class ForumViewController: UIViewController {
    
    var forumPage = ForumPage(forumName: "COMP4977 - iOS", instructor: "Darcy Smith", location: "")

    @IBOutlet weak var forumTitle: UILabel!
    @IBOutlet weak var lbl_instructor: UILabel!
    
    @IBOutlet weak var btn_topic1: UIButton!
    @IBOutlet weak var btn_topic2: UIButton!
    @IBOutlet weak var btn_topic3: UIButton!
    @IBOutlet weak var btn_topic4: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forumTitle.text = "\(forumPage.forumName) Forum"
        self.lbl_instructor.text = "Instructor: \(forumPage.instructor)"
        
        let topic1 = "\(forumPage.forumName) Topic"
        
        self.btn_topic1.setTitle(topic1 + " A", forState: UIControlState.Normal)
        self.btn_topic2.setTitle(topic1 + " B", forState: UIControlState.Normal)
        self.btn_topic3.setTitle(topic1 + " C", forState: UIControlState.Normal)
        self.btn_topic4.setTitle(topic1 + " D", forState: UIControlState.Normal)

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
