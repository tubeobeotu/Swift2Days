//
//  DeadLock.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DeadLock: ConsoleScreen {

    lazy var queueA = {
        return dispatch_queue_create("queueA", DISPATCH_QUEUE_CONCURRENT)
    }()
    
    lazy var queueB = {
        return dispatch_queue_create("queueB", DISPATCH_QUEUE_CONCURRENT)
    }()
    
    
    lazy var semaphoreA = {
        //Passing zero for the value is useful for when two threads need to reconcile
        //the completion of a particular event.
        return dispatch_semaphore_create(0)
    }()
    
    lazy var semaphoreB = {
        return dispatch_semaphore_create(0)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskA()
      
    }
    
    func taskA() {
        dispatch_semaphore_wait(semaphoreB, DISPATCH_TIME_FOREVER)
        dispatch_async(queueB) {
           self.heavyTaskB()
        }
        
        self.writeln("Task A done")
        dispatch_semaphore_signal(semaphoreA)

    }
    
    func heavyTaskB() {
        dispatch_semaphore_wait(semaphoreA, DISPATCH_TIME_FOREVER)
        sleep(Random.within(1...3))
       
        dispatch_async(dispatch_get_main_queue()) {
            self.writeln("Task B done")
        }
        dispatch_semaphore_signal(semaphoreB)

    }
    
}
