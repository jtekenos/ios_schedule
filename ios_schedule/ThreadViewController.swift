//
//  ThreadViewController.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-27.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import RealmSwift

class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    /*
    class Reply: Object {
    
    dynamic var replyId = 0
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var content = ""
    dynamic var postId = 0
    */
    
    var selectedPost : Post!
    var replies : Results<Reply>!
    var currentCreateAction:UIAlertAction!
    var isInEditMode = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedPost.name
        readRepliesAndUpdateUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readRepliesAndUpdateUI() {
        replies = uiRealm.objects(Reply)
        //self.
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
