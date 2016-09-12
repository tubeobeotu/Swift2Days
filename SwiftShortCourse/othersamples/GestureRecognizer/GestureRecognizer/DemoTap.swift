//
//  DemoTap.swift
//  GestureRecognizer
//
//  Created by Trinh Minh Cuong on 10/3/14.
//  Copyright (c) 2014 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DemoTap: UIViewController, UIGestureRecognizerDelegate {
    var grass: UIImageView?
    var ant: UIImageView?
    var tapOnScreen: UITapGestureRecognizer?
    var tapOnAnt: UITapGestureRecognizer?
    
    override func loadView() {
        super.loadView()
        self.edgesForExtendedLayout = UIRectEdge.None
        grass = UIImageView(frame: self.view.bounds)
        grass?.image = UIImage(named: "grass.png")
        self.view.addSubview(grass!)
        
        tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(DemoTap.onTap(_:)))
        tapOnScreen!.delegate = self
        
        self.view.addGestureRecognizer(tapOnScreen!)
    }
    
    func onTap (tap: UITapGestureRecognizer) {
        let point = tap.locationInView(self.view)
        print("tap at x = \(point.x), y = \(point.y)", terminator: "")
        if ant == nil {
            ant = UIImageView(image: UIImage(named: "ant.png"))
            ant?.userInteractionEnabled = true
            ant?.multipleTouchEnabled = true
            tapOnAnt = UITapGestureRecognizer(target: self, action: #selector(DemoTap.zoomInAnt(_:)))
            tapOnAnt?.numberOfTapsRequired = 2
            tapOnAnt?.delegate = self
            
            let longPressOnAnt = UILongPressGestureRecognizer(target: self, action: #selector(DemoTap.resetAnt))
            ant?.addGestureRecognizer(longPressOnAnt)
            ant?.addGestureRecognizer(tapOnAnt!)
            
            let swipeOnAnt = UISwipeGestureRecognizer(target: self, action: #selector(DemoTap.cutAnt))
            swipeOnAnt.direction = UISwipeGestureRecognizerDirection.Down
            ant?.addGestureRecognizer(swipeOnAnt)
            view.addSubview(ant!)
        }
        ant?.center = point
        
    }
    
    func zoomInAnt (tap: UITapGestureRecognizer) {

        ant?.transform = CGAffineTransformConcat(ant!.transform, CGAffineTransformMakeScale(1.2, 1.2))
    }
    
    func resetAnt() {
        ant?.transform = CGAffineTransformIdentity
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer === tapOnScreen) && (otherGestureRecognizer === tapOnAnt) {
            return true
        } else {
            return false
        }
    }
    func cutAnt() {
        //Start timer len
        //
    }
    func onTimer() {
      //  moveHalfOfAntOnParabole(part1)
      //  moveHalfOfAntOnParabole(part2)
    }
    func moveHalfOfAntOnParabole(antPart: UIImageView) {
        
    }
}
