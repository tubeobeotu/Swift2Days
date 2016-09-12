//
//  BaseButton.swift
//  TextField
//
//  Created by ReasonAmu on 8/31/16.
//  Copyright © 2016 ReasonAmu. All rights reserved.
//

import UIKit

class ButtonLogin: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        boderRadiusButton(20)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        boderRadiusButton(20)
       
    }
 
    func boderRadiusButton(radius : CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.baseColor()
     
    }
    func setBackgroundAndBorderWidth(backgroundColor : UIColor , boderWidth : CGFloat , boderColor : UIColor, titleColor: UIColor ){
        self.layer.backgroundColor = backgroundColor.CGColor
        self.layer.borderColor = boderColor.CGColor
        self.layer.borderWidth = boderWidth
        self.setTitleColor(titleColor, forState: .Normal)
   
    }
    
    func setBackgroundAndBorderWidth(backgroundColor : UIColor , boderWidth : CGFloat , boderColor : UIColor){
        self.layer.backgroundColor = backgroundColor.CGColor
        self.layer.borderColor = boderColor.CGColor
        self.layer.borderWidth = boderWidth
        
        
    }
    

}
