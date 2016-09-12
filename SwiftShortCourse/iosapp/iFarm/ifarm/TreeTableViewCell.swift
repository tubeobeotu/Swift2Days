//
//  TreeTableViewCell.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 22/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//

import UIKit

class TreeTableViewCell : UITableViewCell {
    
    @IBOutlet weak var contraintLeft: NSLayoutConstraint!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var customTitleLabel: UILabel!
    
    
    @IBOutlet weak var contraintLeftIcon: NSLayoutConstraint!
    
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var sensorIcon: UIButton!
    
    @IBOutlet weak var contraintCustomLabel: NSLayoutConstraint!
    
    var preSelected = false
    var test_title = ""
    override func awakeFromNib() {
        selectedBackgroundView? = UIView.init()
        selectedBackgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    var additionButtonActionBlock : (TreeTableViewCell -> Void)?;
    
    func setup(withTitle title: String, detailsText: String, level : Int, additionalButtonHidden: Bool) {
        customTitleLabel.text = title
        detailsLabel.text = detailsText
        test_title = detailsText
        
        let left = 30.0 + 20.0 * CGFloat(level)
        contraintLeft.constant = left
        
        contraintLeftIcon.constant = 8 + 20.0 * CGFloat(level)
        contraintCustomLabel.constant = -10 + 10 * CGFloat(level)
        
        iconButton.setImage(UIImage(named: "plus"), forState: .Normal)
        
        if level == 1 {
            detailsLabel.hidden = true
            iconButton.setImage(UIImage(named: "arrow"), forState: .Normal)
            sensorIcon.setImage(UIImage(named: "ManageSensorsBlack"), forState: .Normal)
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.backgroundColor = selected ? UIColor(red: 80.0 / 255.0, green: 174.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0) : UIColor.whiteColor()
    }
    
}