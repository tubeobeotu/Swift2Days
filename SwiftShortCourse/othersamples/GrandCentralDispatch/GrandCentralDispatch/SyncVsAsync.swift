//
//  SyncVsAsync.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/6/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class SyncVsAsync: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        
    }


    @IBAction func doHeavyTaskInMainThread(sender: UIButton) {
        self.heavyTask()
    }

    @IBAction func doHeavyTaskInConcurrentQueue(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { 
            self.heavyTask()
        }
    }
    
    func heavyTask() {
        sleep(2)
    }
}
