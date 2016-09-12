//
//  SemaphoreWait.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/9/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class SemaphoreWait: UIViewController {

    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress3: UIProgressView!
    
    lazy var queueA:dispatch_queue_t = {
        return dispatch_queue_create("queueA", DISPATCH_QUEUE_CONCURRENT)
    }()
    
    
    lazy var queueC:dispatch_queue_t = {
        return dispatch_queue_create("queueB", DISPATCH_QUEUE_CONCURRENT)
    }()
    
    lazy var semaphoreB = {
        //Passing zero for the value is useful for when two threads need to reconcile
        //the completion of a particular event.
        return dispatch_semaphore_create(0)
    }()
    
    lazy var semaphoreC = {
        return dispatch_semaphore_create(0)
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.None
        initUI()
    }
    @IBAction func startDemo(sender: UIButton) {
        initUI()
        dispatch_async(queueA) {
            self.taskA()
        }
        
        dispatch_async(queueA) { 
            self.taskB()
        }
        
        dispatch_async(queueC) {
            self.taskC()
        }
        

    }
    func initUI() {
        progress1.progress = 0.0
        progress2.progress = 0.0
        progress3.progress = 0.0
    }
    
    func taskA() {
        let counter = 1000
        for i in 1...counter {
            usleep(Random.within(800...8000))
            dispatch_async(dispatch_get_main_queue()) {
                self.progress1.progress += 1.0 / Float(counter)
            }
            
            if i == counter/2 {
                dispatch_semaphore_signal(semaphoreB)
            }
        }
        //End
        dispatch_semaphore_signal(semaphoreC)
    }
    
    func taskB() {
        dispatch_semaphore_wait(semaphoreB, DISPATCH_TIME_FOREVER)
        
        let counter = 1000
        for _ in 1...counter {
            usleep(Random.within(800...8000))
            dispatch_async(dispatch_get_main_queue()) {
                self.progress2.progress += 1.0 / Float(counter)
            }
        }
    }
    
    func taskC() {
        dispatch_semaphore_wait(semaphoreC, DISPATCH_TIME_FOREVER)
       
        let counter = 1000
        for _ in 1...counter {
            usleep(Random.within(800...8000))
            dispatch_async(dispatch_get_main_queue()) {
                self.progress3.progress += 1.0 / Float(counter)
            }
        }
       
    }
}
