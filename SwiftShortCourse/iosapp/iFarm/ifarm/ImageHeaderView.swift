//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ImageHeaderView : UIView {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var profileName : UILabel!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.profileName.textColor = UIColor.whiteColor()
        self.profileName.font = UIFont.systemFontOfSize(24)
        self.bottomView.backgroundColor = UIColor.menuColorColor()
        
        
        self.backgroundImage.getImageWithAnimation("img_1.jpg")
    }
    
    func configure(user : User) {
        self.profileName.text = user.displayName
        
        if let urlString = user.userImageUrl {
            let urlImage = NSURL(string: "http://192.168.1.99:8000/\(urlString)")
            self.profileImage.af_setImageWithURL(urlImage!)
        }
        
    }
}