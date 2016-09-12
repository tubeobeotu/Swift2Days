//
//  DispatchApply.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DispatchApply: ConsoleScreen {

    lazy var concurrentQueue = {
       return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    }()
    
    var bigArray = Array(count: 5, repeatedValue: Array(count: 100, repeatedValue: 0))
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.writeln("List max value in each row of 2D array")
        
        let n = bigArray.count;
        
        for i in 0..<n {
            for j in 0..<bigArray[0].count {
                bigArray[i][j] = Random.within(0...1000)
            }
        }
        dispatch_apply(n, concurrentQueue) { (i) in
            
            let maxNum = self.bigArray[i].maxElement()!
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.writeln("\(i) : \(maxNum)")
            })
        }
    }



}
