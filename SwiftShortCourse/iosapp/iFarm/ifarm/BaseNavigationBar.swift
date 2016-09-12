//
//  BaseNavigationBar.swift
//  iFram
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
import UIKit
class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        setupNavigation()
    }
    func setupNavigation() {
        UINavigationBar.appearance().barTintColor = UIColor.baseColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = ([NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    
}