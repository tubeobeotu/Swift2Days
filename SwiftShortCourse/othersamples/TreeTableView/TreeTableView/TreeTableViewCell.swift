//
//  TreeTableViewCell.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 22/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//

import UIKit

class TreeTableViewCell : UITableViewCell {

    @IBOutlet private weak var additionalButton: UIButton!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var customTitleLabel: UILabel!
    
    private var additionalButtonHidden : Bool {
        get {
            return additionalButton.hidden;
        }
        set {
            additionalButton.hidden = newValue;
        }
    }


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
        self.additionalButtonHidden = additionalButtonHidden
    
        let left = 11.0 + 20.0 * CGFloat(level)
        self.customTitleLabel.frame.origin.x = left
        self.detailsLabel.frame.origin.x = left
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
        self.backgroundColor = selected ? UIColor(red: 80.0 / 255.0, green: 174.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0) : UIColor.whiteColor()
    }
    func additionButtonTapped(sender : AnyObject) -> Void {
        if let action = additionButtonActionBlock {
            action(self)
        }
    }

}