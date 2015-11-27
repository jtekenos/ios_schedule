//
//  Post.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-27.
//  Copyright © 2015 Jess. All rights reserved.
//

import Foundation
import RealmSwift

class Post: Object {
    dynamic var postId = 0
    dynamic var name = ""
    dynamic var userName = ""
    dynamic var createdAt = NSDate()
    dynamic var content = ""
    let replies = List<Reply>()
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
