//
//  Helper.swift
//  WrapAPI
//
//  Created by Vinh The on 9/7/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import Foundation


//
//let BASE_URL = "http://localhost:3000/api"//local
let BASE_URL = "http://192.168.1.99:8000/api"//online

let authorization = AuthorizationManager.shareInstance
let router = Router.shareInstance

var refreshTokenCode : String = "" //Refresh Token
var header = [String:String]() // Header
let keychain = Keychain(service: "iFarm.keychain") // Keychain
let mainDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegate

public typealias NetworkSuccessHandler = (AnyObject?) -> Void // closure Success
public typealias NetworkFailureHandler = (NSError) -> Void // closure Failed
