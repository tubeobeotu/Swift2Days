//
//  AppDelegate.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/6/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        BootLogic.boot(self.window!)
        self.window?.makeKeyAndVisible()
        return true
    }

}

