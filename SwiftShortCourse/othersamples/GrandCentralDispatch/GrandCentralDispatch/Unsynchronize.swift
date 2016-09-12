//
//  Unsynchronize.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/9/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//  khi chạy sẽ bị crash ở self.number = Int(arc4random())
// hoặc giá trị khi set và get sẽ không giống nhau

import UIKit

class Unsynchronize: ConsoleScreen {

    lazy var queue = {
        return dispatch_queue_create("ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demoUnsynchronize()
        
    }

    var number: Int = 0
    func demoUnsynchronize() {
        
        for i in 1...10 {
            dispatch_async(queue, {
                usleep(Random.within(8000...18000))
                
                self.number = Int(arc4random()%100) //This cause crashes!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.writeln("At \(i) number is set \(self.number)")
                })
                
                usleep(Random.within(8000...18000))
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.writeln("At \(i) number is get \(self.number)")
                })
                
            })
        }
    }


}
