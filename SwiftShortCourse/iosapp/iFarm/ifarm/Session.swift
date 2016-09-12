//
//  Session.swift
//  iFarm
//
//  Created by Vinh The on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation

class Session {
    
    let accessToken : String
    let authScheme : String
    let refreshToken : String
    
    init(sessionInfo : JSON){
        self.accessToken = sessionInfo["accessToken"].string!
        self.authScheme = sessionInfo["authScheme"].string!
        self.refreshToken = sessionInfo["refreshToken"].string!
    }
    
    func accessTokenFinal() -> String {
        return "\(authScheme) \(accessToken)"
    }
    
}