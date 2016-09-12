//
//  Header.swift
//  DemoAlamoreFire
//
//  Created by Vinh The on 8/30/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation

let baseURL = "https://demo-alamofire-api.herokuapp.com"

let getAllAPI = "/persons"

let createPersonAPI = "/person/"

let IMAGE_URL = "http://192.168.1.99:3000"

//let IMAGE_URL = "http://localhost:8000" // test

var header = ["authorization":"JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZXhwIjoxNDc2MTgwMDQyLCJpYXQiOjE0NzM1ODgwNDIsImp0aSI6IkxJM0FsVlYxeXFaOE11U3BRNnI0MUVjenBqbS96WHo5RXgwNldSanlWbklaeFloV0svWDNGSCttZnRnNUJXV1VmdTVtTDdhV0FHODdhVGlzdlBPRmx3PT0ifQ.6VfEheJNZcY0w_l_qkNbO37ADJ7VOriAep2de36VI3Q"]

let UPLOAD_IMAGE_API = "/api/create-image"

let GET_IMAGE_API = "/api/image-list"

let LOGIN_API = "/api/login"

let REFRESH_TOKEN_API = "/api/refresh-token"


//
let DOCUMENT_URL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        