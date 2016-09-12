//
//  ExtensionAPI.swift
//  iFarm
//
//  Created by Vinh The on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation

//Extension dùng mở rộng
extension Router{
    
    //API LOGIN
    func login(param : [String : AnyObject]?,success : NetworkSuccessHandler, failled : NetworkFailureHandler) {
        postRequest(.Login, param: param, success: { (data) in
            success(data)
        }) { (error) in
            failled(error)
        }
    }
    
    //GET USER INFORMATION
    
    func getUserInformation(success : NetworkSuccessHandler, failled : NetworkFailureHandler) {
        getRequest(.GetUserInformation, success: { (data) in
            
            let json = JSON(data: data as! NSData)
            let user = User(userInformation: json)
            success(user)
        }) { (error) in
            print(error)
        }
    }
    
    //API GET ALL FARM
    func getFarm(page : Int ,success : NetworkSuccessHandler, failed : NetworkFailureHandler )  {
        
        getRequest(.GetAllFarms(page), success: { (data) in
            
            success(data)
            
        }) { (error) in
            failed(error)
        }
    }
    
    //API GET ALL SENSOR
    func getSensorWithFarmID(farmID : String ,success : NetworkSuccessHandler, failed : NetworkFailureHandler) {
        getRequest(.GetSensorWithFarmID(farmID), success: { (data) in
            
            let json = JSON(data: data as! NSData)
            
            var sensorArray = [Sensor]()
            
            for (_, sensorInformation) in json{
                let sensor = Sensor(sensorInformation: sensorInformation)
                
                sensorArray.append(sensor)
            }
            
            success(sensorArray)
        }) { (error) in
            failed(error)
        }
    }
    
    //REGISTER USER
    
    func registerUser(param : [String : AnyObject]?, success : NetworkSuccessHandler, failed : NetworkFailureHandler) {
        postRequest(.RegisterUser, param: param, success: { (data) in
            success(data)
        }) { (error) in
            failed(error)
        }
    }
    
    
    //CREATE FARM
    
    func createFarm(params : [String : AnyObject]?, success : NetworkSuccessHandler, failed : NetworkFailureHandler) {
        
        postRequest(.CreateFarm, param: params, success: { (data) in
            success(data)
        }) { (error) in
            failed(error)
        }
    }
    
    //CREATE Sensor
    
    func createSensor(params : [String : AnyObject]?, success : NetworkSuccessHandler, failed : NetworkSuccessHandler) {
        
        postRequest(.CreateSensorWithFarmID, param: params, success: { (data) in
            success(data)
        }) { (error) in
            failed(error)
        }
        
    }
    
    //Delete Farm
    
    func deleteFarm(farmID : String, success : NetworkSuccessHandler, failed : NetworkSuccessHandler) {
        deleteRequest(.DeleteFarm(farmID), success: { (data) in
            success(data)
        }) { (error) in
            failed(error)
        }
    }
    
    //Delete Sensor
    
    func deleteSensor(sensorID : String, success : NetworkSuccessHandler, failed : NetworkSuccessHandler) {
        
        deleteRequest(.DeleteSensor(sensorID), success: { (data) in
            success(data)
        }) { (error) in
            failed(error)
        }
    }
    
}
