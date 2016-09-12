//
//  SerialVsConcurrent.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/7/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class SerialVsConcurrent: ConsoleScreen {

    var serialQueue: dispatch_queue_t?
    var concurrentQueue: dispatch_queue_t?
    override func viewDidLoad() {
        super.viewDidLoad()
        //demoSerialQueue()
        demoConcurrentQueue()
    }
    
    func demoSerialQueue() {
        self.writeln("Serial: tác vụ hoàn thành theo thứ tự vào queue")
        serialQueue = dispatch_queue_create("vn.techmaster.SerialQueue", DISPATCH_QUEUE_SERIAL)
        guard serialQueue != nil else {
            return
        }
        dispatch_async(serialQueue!) {
            self.heavyTask1()
        }
        
        dispatch_async(serialQueue!) {
            self.heavyTask2()
        }
    }
    
    func demoConcurrentQueue(){
        self.writeln("Concurrent: Tác vụ xong trước, trả về trước")
        concurrentQueue = dispatch_queue_create("vn.techmaster.ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT)
        
        guard concurrentQueue != nil else {
            return
        }
        dispatch_async(concurrentQueue!) {
            self.heavyTask1()
        }
        
        dispatch_async(concurrentQueue!) {
            self.heavyTask2()
        }
    }
    
    func heavyTask1() {
        sleep(Random.within(1...3))
        dispatch_async(dispatch_get_main_queue()) { 
            self.writeln("heavy task 1 completes")
        }
    }
    func heavyTask2() {
        sleep(Random.within(1...3))
        dispatch_async(dispatch_get_main_queue()) {
            self.writeln("heavy task 2 completes")
        }
    }
}
