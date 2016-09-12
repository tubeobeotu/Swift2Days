//
//  DispatchAfter.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DispatchAfter: UIViewController {

    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progressTask: UIProgressView!
    var taskIsRunning: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        delaySlider.minimumValue = 0.1  //second
        delaySlider.maximumValue = 2.0  //second
        delaySlider.value = 1.0
    }
    @IBAction func onSliderDelayChange(sender: UISlider) {
        startButton.setTitle("Run task after \(delaySlider.value) seconds", forState: UIControlState.Normal)
    }

    @IBAction func startATask(sender: AnyObject) {
        progressTask.progress = 0.0
        startButton.enabled = false
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(Double(delaySlider.value) * Double(NSEC_PER_SEC))
            ),
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.heavyTask({
                    dispatch_async(dispatch_get_main_queue()) {
                        self.startButton.enabled = true
                    }
                })
        })
        
    }

    //Call notifyDone when heavyTask completes
    func heavyTask(notifyDone: ()->()) {
        let counter = 1000
        for _ in 1...counter {
            usleep(Random.within(800...8000))
            dispatch_async(dispatch_get_main_queue()) {
                self.progressTask.progress += 1.0 / Float(counter)
            }
        }
        notifyDone()
        
        
    }
    
    

}
