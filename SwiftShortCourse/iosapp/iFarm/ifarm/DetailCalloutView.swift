//
//  detailCalloutView.swift
//  SimpleMapKit
//
//  Created by ReasonAmu on 9/7/16.
//  Copyright © 2016 ReasonAmu. All rights reserved.
//

import UIKit

class DetailCalloutView: UIView {
    
    var label:UILabel!
    var imageView:UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: frame.width)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: frame.height)
      
        self.addConstraints([widthConstraint,heightConstraint])
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelName(frame : CGRect,text: String, textAlignment : NSTextAlignment,fontSize:CGFloat){
        
        label = UILabel(frame:frame)
        label.numberOfLines = 0
        label.textAlignment = textAlignment
        label.text = text
        label.font = UIFont.systemFontOfSize(fontSize)
        
        //--
        self.addSubview(label)
    }
    
    func setImage(frame :CGRect,image: UIImage, contenMode : UIViewContentMode){
         self.imageView = UIImageView(frame: frame)
         self.imageView.contentMode = contentMode
         self.imageView.image = image
         self.addSubview(imageView)
    }
   

    

}
