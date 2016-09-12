//
//  Ambiguity.swift
//  GestureRecognizer
//
//  Created by cuong minh on 3/16/15.
//  Copyright (c) 2015 Techmaster Vietnam. All rights reserved.
//

import UIKit

class Ambiguity: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var girl: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        girl.userInteractionEnabled = true
        girl.multipleTouchEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Ambiguity.onTap(_:)))
        tap.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(Ambiguity.onLongPress(_:)))
        longPress.delegate = self
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(Ambiguity.onPan(_:)))
        pan.delegate = self
        
        girl.addGestureRecognizer(tap)
        girl.addGestureRecognizer(longPress)
        girl.addGestureRecognizer(pan)
    }
    
    func onTap(tap: UITapGestureRecognizer) {
        print("tap", terminator: "")
    }
    
    func onLongPress(longPress: UILongPressGestureRecognizer){
        print("Long Press", terminator: "")
    }
    
    func onPan(pan: UIPanGestureRecognizer){
            // if (pan.state == UIGestureRecognizerState.Began || pan.state == UIGestureRecognizerState.Changed) {
            pan.view!.center = pan.locationInView(self.view)
            //pan.view có thể thay thế hoàn toàn cho target
            //target!.center = pan.locationInView(self.view)
            //}
    }
    //gestureRecognizer chỉ được nhận dạng khi otherGestureRecognizer fail
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.isMemberOfClass(UITapGestureRecognizer)) && (otherGestureRecognizer.isMemberOfClass(UILongPressGestureRecognizer)) {
            return false
        } else {
            return true
        }
        
    }

  

}
