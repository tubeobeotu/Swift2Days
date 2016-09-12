//
//  Item.swift
//  PineDecor
//
//  Created by DangCan on 4/13/16.
//  Copyright © 2016 DangCan. All rights reserved.
//

import UIKit


class Item: UIImageView, UIGestureRecognizerDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    func setup()
    {
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(Item.onPan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)
        
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(Item.pinchPhoto(_:)))
        self.addGestureRecognizer(pinchGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(Item.rotateItem(_:)))
        rotateGesture.delegate = self
        self.addGestureRecognizer(rotateGesture)
    }
    func onPan(panGesture: UIPanGestureRecognizer)
    {
        if (panGesture.state == .Began || panGesture.state == .Changed)
        {
            let point = panGesture.locationInView(self.superview)
            self.center = point;
            
        }
        
    }
    func pinchPhoto(pinchGestrureRecognizer: UIPinchGestureRecognizer)
    {
//        self.adjustAnchorPointForGestureRecognizer(pinchGestrureRecognizer)
        if let view = pinchGestrureRecognizer.view
        {
            view.transform = CGAffineTransformScale(view.transform,
                pinchGestrureRecognizer.scale, pinchGestrureRecognizer.scale)
            pinchGestrureRecognizer.scale = 1
        }
    }
    func rotateItem(rotateGestureRecognizer: UIRotationGestureRecognizer)
    {
//        self.adjustAnchorPointForGestureRecognizer(rotateGestureRecognizer)
        if let view = rotateGestureRecognizer.view
        {
            view.transform = CGAffineTransformRotate(view.transform, rotateGestureRecognizer.rotation)
            rotateGestureRecognizer.rotation = 0
        }
        
    }
    func adjustAnchorPointForGestureRecognizer(gestureRecognizer: UIGestureRecognizer)
    {
        if (gestureRecognizer.state == .Began)
        {
            let locationInCurrentView = gestureRecognizer.locationInView(gestureRecognizer.view)
            let locationInSuperView = gestureRecognizer.locationInView(gestureRecognizer.view!.superview)
            self.layer.anchorPoint = CGPointMake(locationInCurrentView.x / gestureRecognizer.view!.bounds.size.width, locationInCurrentView.y / gestureRecognizer.view!.bounds.size.height)
            self.center = locationInSuperView
        }
    }

}
