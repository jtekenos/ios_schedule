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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forumTitle.text = "Whatever Forum"
        // Do any additional setup after loading the view.
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
