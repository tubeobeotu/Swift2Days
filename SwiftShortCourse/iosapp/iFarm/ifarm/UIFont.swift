//
//  UIFont.swift
//  iFram
//
//  Created by Tuuu on 9/1/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit
extension UIFont
{
    class func fontMenu() -> NSAttributedString
    {
        return NSAttributedString(string: "fontMenu", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(),  NSFontAttributeName: UIFont(name: "Arial", size: 18.0)!])
    }
    class func fontProfile() -> NSAttributedString
    {
        return NSAttributedString(string: "fontProfile", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(),  NSFontAttributeName: UIFont(name: "Arial", size: 24.0)!])
    }
}