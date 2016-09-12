//
//  PersonCell.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/11/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var dob: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
