//
//  TwoBallsCollide.swift
//  GestureRecognizer
//
//  Created by cuong minh on 1/2/15.
//  Copyright (c) 2015 Techmaster Vietnam. All rights reserved.
//

import UIKit
class Ball : UIImageView {
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var vX: CGFloat = 0.0
    var vY: CGFloat = 0.0
    var r: CGFloat = 32.0
    func move() {
        
    }
    func checkCollideWithBound(bound: CGRect) -> Bool {
        return true
    }
    
    func checkCollideWithOtherBall(otherBall: Ball) -> Bool {
        let doubleRadiusSquare: CGFloat = 4.0 * r * r
        if doubleRadiusSquare - pow((x - otherBall.x), 2) - pow((y - otherBall.y), 2) < 0.01  {
            return true
        } else {
            return false
        }
    }
}
class TwoBallsCollide: UIViewController {

    var ball1: Ball!
    var ball2: Ball!
    var bound: CGRect!
    var timer: NSTimer!
    override func viewDidLoad() {
        super.viewDidLoad()
        bound = view.bounds
        //Kich hoat timer de chay loop o day
    }
    
    func loop () {
        ball1.checkCollideWithBound(bound)
        ball2.checkCollideWithBound(bound)
        ball1.checkCollideWithOtherBall(ball2)
        
    }


}
