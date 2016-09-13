//
//  ExtendBarButtonItem.swift
//  DemoTable
//
//  Created by cuong minh on 11/18/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import UIKit
extension UIBarButtonItem {

    convenience init (image: UIImage, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .Custom)
        button.bounds = CGRect(origin: CGPoint.zero, size: image.size)
        button.setImage(image, forState: UIControlState.Normal)
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        self.init(customView: button)
    }
}