//
//  AuthManager.swift
//  WrapAPI
//
//  Created by Vinh The on 9/6/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import Foundation
import Alamofire
public class AuthorizationManager: Manager {
    
    private typealias CachedTask = (NSHTTPURLResponse?, AnyObject?, NSError?) -> Void // Private closure cho các task gặp 401.
    
    private var cachedTasks = Array<CachedTask>()
    
    var isRefreshing = false
    
    class var shareInstance: AuthorizationManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AuthorizationManager? = nil
        }
        
        dispatch_once(&Static.onceToken){
            
            Static.instance = AuthorizationManager()
        }
        
        return Static.instance!
        
        
    }
    
    public func startRequest(
        method method: Alamofire.Method,
               URLString: URLStringConvertible,
               parameters: [String: AnyObject]?,
               headers : [String : String]?,
               encoding: ParameterEncoding,
               success: NetworkSuccessHandler?,
               failure: NetworkFailureHandler?
        ) -> Request?
    {
        
        // Sử dụng weak self để đảm bảo không gặp retain cycle
        let cachedTask: CachedTask = { [weak self] URLResponse, data, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                failure?(error)
            } else {
                strongSelf.startRequest(
                    method: method,
                    URLString: URLString,
                    parameters: parameters,
                    headers: header,
                    encoding: encoding,
                    success: success,
                    failure: failure
                )
            }
        }
        
        if self.isRefreshing {
            self.cachedTasks.append(cachedTask)
            return nil
        }
        
        let request = self.request(method, URLString, parameters: parameters, encoding: encoding, headers : header)
        
        request.validate()
                .response {[weak self] (request, response, data, error) in
             guard let strongSelf = self else { return }
            
            if let response = response where response.statusCode == 401{
                strongSelf.cachedTasks.append(cachedTask)
                strongSelf.refreshTokens()
                return
            }
            
            if let error = error{
                print(error)
                failure?(error)
            }else{
                success?(data)
            }
        }
        
        return request
    }
    
    func refreshTokens() {
        self.isRefreshing = true
        
        //Chạy refreshToken.
        Token().refreshToken {
            let cachedTaskCopy = self.cachedTasks
            self.cachedTasks.removeAll()
            self.isRefreshing = false
            print(cachedTaskCopy.count)
            cachedTaskCopy.map{ $0(nil, nil, nil) }
        }
    }
    
    
    
    
    
}