//
//  CurrentUser.swift
//  ios_schedule
//
//  Created by Denis Turitsa on 2015-11-26.
//  Copyright © 2015 Jess. All rights reserved.
//

import Foundation

import Foundation
class CurrentUser {
    var userName:String
    var set:String
    
    init(userName:String, set:String) {
        self.userName = userName
         self.set = set
    }

}
var CurrentUserInstance = CurrentUser(userName:"defaultName", set:"defaultSet")