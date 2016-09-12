//
//  BaseTextField.swift
//  TextField
//
//  Created by ReasonAmu on 8/30/16.
//  Copyright © 2016 ReasonAmu. All rights reserved.
//

import UIKit

enum TagTextField {
    case User
    case Password
}



class TextFieldLogin: UITextField {
    
    let  numberTag:Int = 100
    let  placeHolderUser = "Tên đăng nhập"
    let  placeHolderPassword = "Mật khẩu"
    
    //-- show and Hidden icon
    func showAndHiddenIconTextField(textField :UITextField, showAndHidden : Bool ){
        
        if(showAndHidden){
            textField.leftViewMode  = .Always
            stringPlacaHolder(textField)
        }else{
            textField.leftViewMode = .Never
        }
        
    }
    
    //-- String placeHolder : User --- Password
    
    func stringPlacaHolder (textField : UITextField){
        
        if(textField.tag ==  TagTextField.User.hashValue + numberTag){
            
            textField.placeholder = placeHolderUser
            
            
        }else if (textField.tag == TagTextField.Password.hashValue + numberTag){
            
            textField.placeholder = placeHolderPassword
            
        }
    }
    
    //-- add Icon TextField
    func addIconTextField(textField : UITextField, stringImage : String){
        let img = UIImageView(image: UIImage(named: stringImage))
        img.frame = CGRectMake(0, 0, img.frame.width + 10 , textField.frame.height)
        textField.leftView = img
        textField.leftView?.contentMode = .Center
    
        //-- call func showHidden
        showAndHiddenIconTextField(textField, showAndHidden: true)
        
    }
    
    //-- bo goc textfield
    func roundCorners(corners : UIRectCorner ,radius : CGFloat) {
        let bounds = self.bounds //-- lay bound cua textfield
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.CGPath
        
        self.layer.mask = maskLayer
        
        
        //--
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.CGPath
        frameLayer.strokeColor = UIColor.lightGrayColor().CGColor
        frameLayer.fillColor = UIColor.whiteColor().CGColor
        
        self.layer.addSublayer(frameLayer)
        
        
    }
    func roundTopCornersRadius(radius : CGFloat){
        self.roundCorners([.TopLeft, .TopRight], radius: radius)
    }
    
    func roundBottomCornersRadius(radius : CGFloat){
        self.roundCorners([.BottomLeft, .BottomRight], radius: radius)
    }
}































