//
//  Reply.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-27.
//  Copyright © 2015 Jess. All rights reserved.
//

import Foundation
import RealmSwift

class Reply: Object {
    
    dynamic var replyId = 0
    dynamic var name = ""
    dynamic var createdAt = ""
    dynamic var author = ""
    dynamic var content = ""
    dynamic var postId = 0
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
