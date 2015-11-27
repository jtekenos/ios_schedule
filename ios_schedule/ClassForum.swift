//
//  ClassForum.swift
//  ios_schedule
//
//  Created by Jessica Tekenos on 2015-11-27.
//  Copyright © 2015 Jess. All rights reserved.
//

import Foundation
import RealmSwift

class ClassForum: Object {
    
    dynamic var classForumId = 0
    dynamic var name = ""
    dynamic var instructor = ""
    let posts = List<Post>()
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
