//
//  Item.swift
//  TableCell
//
//  Created by HoangHai on 8/31/16.
//  Copyright © 2016 CanhDang. All rights reserved.
//

import Foundation

class Sensor {
    let id: String
    let farmId: String
    let description: String?
    var longitude: Float?
    var latitude: Float?
    let status: Int?
    let createdAt: String?
    let createdBy: String?
    let modifiedAt: String?
    var sensorData: SensorData?
    
    init(sensorInformation : JSON){
        
        self.id = sensorInformation["id"].string!
        self.farmId = sensorInformation["farmId"].string!
        self.description = sensorInformation["description"].string
        
        self.longitude = sensorInformation["longitude"].float
        
        self.latitude = sensorInformation["latitude"].float
        
        self.status = sensorInformation["status"].int
        self.createdAt = sensorInformation["createdAt"].string
        self.createdBy = sensorInformation["createdBy"].string
        self.modifiedAt = sensorInformation["modifiedAt"].string
        
        for (_,sensorDataObject) in sensorInformation["sensor_data"]{
            
            self.sensorData = SensorData(sensorData: sensorDataObject)
            
        }
        
    }
}


class SensorData {
    let id: String?
    let sensorId: String?
    let temperature: Float?
    let moisture: Float?
    let pH : Float?
    let battery : Float?
    let note : String?
    let createAt : String?
    
    init(sensorData : JSON){
        self.id = sensorData["id"].string
        self.sensorId = sensorData["sensorID"].string
        self.temperature = sensorData["temperature"].float
        self.moisture = sensorData["moisture"].float
        self.pH = sensorData["pH"].float
        self.battery = sensorData["battery"].float
        self.note = sensorData["note"].string
        self.createAt = sensorData["createAt"].string
        
    }
    
}









