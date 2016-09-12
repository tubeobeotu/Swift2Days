//
//  DispatchOnce.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DispatchOnce: ConsoleScreen {

    override func viewDidLoad() {
        super.viewDidLoad()

        var token: dispatch_once_t = 0
        func test(i: Int) {
            dispatch_once(&token) {
                self.writeln("This runs only one")
            }
            self.writeln("print \(i)")
        }
        
        for i in 0..<4 {
            test(i)
        }
    }

    
}
