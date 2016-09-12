//
//  User.swift
//  ifarm
//
//  Created by Techmaster on 8/28/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation

class User {
    let id : String?
    let userEmail : String?
    let userPhone: String?
    let userRegistered: String?
    let displayName: String?
    let userImageUrl : String?
    let userStatus : Bool?
    
    init(userInformation : JSON){
        
        self.id = userInformation["id"].string
        self.userEmail = userInformation["user_email"].string
        self.userPhone = userInformation["user_phone"].string
        self.userRegistered = userInformation["user_registered"].string
        self.displayName = userInformation["display_name"].string
        self.userImageUrl = userInformation["user_image_url"].string
        self.userStatus = userInformation["user_status"].bool
    }
}