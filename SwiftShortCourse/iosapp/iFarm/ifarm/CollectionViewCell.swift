//
//  CollectionViewCell.swift
//  CollectionViewTest
//
//  Created by Le Ha Thanh on 9/1/16.
//  Copyright © 2016 le ha thanh. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sensorLabel: UILabel!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var farmNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        settingCell()
    }
    
    func settingCell() {
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.menuColorColor().CGColor
        drawCornerRadius(contentView, rectCorner: [.TopLeft, .TopRight, .BottomLeft, .BottomRight], radius: CGSizeMake(4, 4), borderColor: UIColor.redColor())
    }
    func drawCornerRadius(view : UIView, rectCorner : UIRectCorner, radius : CGSize, borderColor : UIColor) {
        
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: radius) 
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        maskLayer.borderWidth = 1.0
        view.layer.mask = maskLayer
        
    }
    
    func configureCell(farm : Farm) {
        
        sensorLabel.text = String(farm.sensorCount!)
        
        // farm.lastModified co the tra ve nil
        if let lastModified = farm.lastModified {
            
            dateLabel.text = splitedTimeReturn(lastModified)
            
        } else {
            dateLabel.text = "No information"
        }
        
        alertLabel.text = String(arc4random_uniform(300) + 100)
        
        farmNameLabel.text = farm.title
        
    }
    
    // Tra ve 10 ky tu dau tien de lay ra ngay tu lastModified
    func splitedTimeReturn(time: String) -> String {
        let splitedTime: String = (time as NSString).substringToIndex(10)
        return splitedTime
    }
}
