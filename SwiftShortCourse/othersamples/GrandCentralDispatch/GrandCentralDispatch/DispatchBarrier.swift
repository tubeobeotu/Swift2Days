//
//  DispatchBarrier.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DispatchBarrier: UIViewController {

    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress3: UIProgressView!
    @IBOutlet weak var progress4: UIProgressView!
    @IBOutlet weak var imageDone: UIImageView!
    
    lazy var concurrentQueue : dispatch_queue_t = {
        return dispatch_queue_create("vn.techmaster.concurrentQueue", DISPATCH_QUEUE_CONCURRENT)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        initUI()
    }

    func initUI() {
        progress1.progress = 0.0
        progress2.progress = 0.0
        progress3.progress = 0.0
        progress4.progress = 0.0
        imageDone.hidden = true
        
    }

    
    @IBAction func startAllTasks(sender: AnyObject) {
        initUI()
        dispatch_async(concurrentQueue) { 
            self.heavyTask(1)
        }
        dispatch_async(concurrentQueue) {
            self.heavyTask(2)
        }
        dispatch_barrier_async(concurrentQueue) { 
            self.heavyTask(3)
        }
        dispatch_barrier_async(concurrentQueue) {
            self.heavyTask(4)
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.imageDone.hidden = false
                self.startButton.enabled = true
            })
        }
    }
    
    func heavyTask(n: Int) {
        let counter = 1000
        for _ in 1...counter {
            usleep(Random.within(800...8000))
            dispatch_async(dispatch_get_main_queue()) {
                switch n {
                case 1:
                    self.progress1.progress += 1.0 / Float(counter)
                case 2:
                    self.progress2.progress += 1.0 / Float(counter)
                case 3:
                    self.progress3.progress += 1.0 / Float(counter)
                default:
                    self.progress4.progress += 1.0 / Float(counter)
                    
                }
            }
        }
    }

  
}
