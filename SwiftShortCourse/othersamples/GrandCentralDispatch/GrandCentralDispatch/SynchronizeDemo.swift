//
//  SynchronizeDemo.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/9/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
// Sử dụng barrier_async có tác dụng gì?
// Để ý thấy vẫn có giá trị lấy ra khác với giá trị gán vào. Hãy đề xuất cách giải quyết đảm bảo tính toàn vẹn dữ liệu

import UIKit

class SynchronizeDemo: ConsoleScreen {

    lazy var queue = {
        return dispatch_queue_create("ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demoSynchronize()
        
    }
    
    var number: Int = 0
    
    func demoSynchronize() {
        for i in 1...10 {
            dispatch_barrier_async(queue, {
                usleep(Random.within(8000...28000))
               
                self.number = Int(arc4random()%100) //This cause crashes!
                dispatch_async(dispatch_get_main_queue(), {
                   self.writeln("At \(i) number is set \(self.number)")
                })
                    
                usleep(Random.within(8000...28000))
              
                dispatch_async(dispatch_get_main_queue(), {
                   self.writeln("At \(i) number is get \(self.number)")
                })
              
            })
        }
    }

}
