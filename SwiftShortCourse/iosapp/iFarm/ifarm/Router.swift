//
//  Router.swift
//  WrapAPI
//
//  Created by Vinh The on 9/7/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import Foundation
import Alamofire


//Tạo enum để quản lí Path của API
enum Path:URLStringConvertible {
    case Login
    case RefreshToken
    case CreateFarm
    case GetAllFarms(Int)
    case DeleteFarmsWithID(String)
    case CreateSensorWithFarmID
    case GetSensorWithFarmID(String)
    case RegisterUser
    case GetUserInformation
    case DeleteFarm(String)
    case DeleteSensor(String)
    
    var URLString: String {
        switch self {
        case .Login: return "/login"
        case .RefreshToken: return "/refresh-token"
        case .CreateFarm: return "/farm/create"
        case .GetAllFarms(let page): return "/farms/page/\(page)"
        case .DeleteFarmsWithID(let farmID): return "/farm/\(farmID)"
        case .CreateSensorWithFarmID: return "/farm/sensor"
        case .GetSensorWithFarmID(let farmID): return "/sensors?farmId=\(farmID)"
        case .RegisterUser: return "/register"
        case .GetUserInformation: return "/user"
        case .DeleteFarm(let farmID): return "/farm/\(farmID)"
        case .DeleteSensor(let sensorID): return "/sensor/\(sensorID)"
        }
    }
}

class Router {
    class var shareInstance: Router {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Router? = nil
        }
        
        dispatch_once(&Static.onceToken){
            Static.instance = Router()
        }
        
        return Static.instance!
    }
    
    
    func postRequest(path : Path, param : [String : AnyObject]?, success : NetworkSuccessHandler, failed : NetworkFailureHandler) {
        
        AuthorizationManager.shareInstance.startRequest(method: .POST,
                                                        URLString: "\(BASE_URL)\(path.URLString)",
                                                        parameters: param,
                                                        headers: header,
                                                        encoding: .URL,
                                                        success: { (data) in
                                                            
                                                            success(data)
        }) { (error) in
            failed(error)
        }
    }
    
    
    func getRequest(path : Path, success : NetworkSuccessHandler, failed : NetworkFailureHandler) {
        
        AuthorizationManager.shareInstance.startRequest(method: .GET,
                                                        URLString: "\(BASE_URL)\(path.URLString)",
                                                        parameters: nil,
                                                        headers: header,
                                                        encoding: .URL,
                                                        success: { (data) in
                                                            success(data)
        }) { (error) in
            failed(error)
        }
    }
    
    func deleteRequest(path : Path, success : NetworkSuccessHandler, failed : NetworkFailureHandler) {
        print(BASE_URL + path.URLString)
        
        AuthorizationManager.shareInstance.startRequest(method: .DELETE,
                                                        URLString: "\(BASE_URL)\(path.URLString)",
                                                        parameters: nil,
                                                        headers: header,
                                                        encoding: .URL,
                                                        success: { (data) in
                                                            
                                                            success(data)
        }) { (error) in
            failed(error)
        }
        
    }
}

class Token {
    //Hàm refresh Token
    func refreshToken(completionHandle : (()->Void)) {
        Alamofire.request(.POST, "\(BASE_URL)\(Path.RefreshToken.URLString)", parameters: ["refreshToken":refreshTokenCode], headers: header).response { (request, response, data, error) in
            
            //Nếu refreshToken hết hạn thì logout
            if let response = response where response.statusCode == 401{
                //Logout to login view
                self.resetKeyChain()
            }else if let response = response where response.statusCode == 500{
                self.resetKeyChain()
            }else{
                let json = JSON(data: data!)
                //Tạo đối tượng Session.
                let session = Session(sessionInfo: json)
                //Update lại accessToken và refreshToken trong KeyChainAccess
                keychain["accessToken"] = session.accessTokenFinal()
                keychain["refreshToken"] = session.refreshToken
                //Update lại header và refreshToken.
                header["authorization"] = keychain["accessToken"]
                refreshTokenCode = keychain["refreshToken"]!
                completionHandle()
            }
            
        }
    }
    
    func resetKeyChain() {
        keychain["accessToken"] = nil
        keychain["refreshToken"] = nil
        mainDelegate.resetRootViewController()
        authorization.isRefreshing = false
    }
}
