//
//  TextViewCornerRadius.swift
//  iFram
//
//  Created by Tuuu on 9/2/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit
class TextViewCornerRadius: UITextView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        customTextField()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: .None)
        customTextField()
    }

    func customTextField(){
        layer.cornerRadius = 4
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 0.3
    }
}