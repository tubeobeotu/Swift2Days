//
//  Farm.swift
//  ifarm
//
//  Created by Techmaster on 8/28/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation

class Farm {
    let id : String
    let title : String?
    let imageURL : String?
    let description : String
    let owner : String
    let sensorCount : Int?
    let lastModified : String?
    
    init(farmInfo : JSON){
        self.id = farmInfo["id"].string!
        self.title = farmInfo["title"].string
        self.imageURL = farmInfo["imageURL"].string
        self.description = farmInfo["description"].string!
        self.owner = farmInfo["owner"].string!
        self.sensorCount = farmInfo["sensorCount"].int!
        self.lastModified = farmInfo["lastModified"].string
    }
    
}