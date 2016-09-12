//
//  PersonCell.swift
//  DemoAlamoreFire
//
//  Created by Vinh The on 8/30/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(person : Person) {
        textLabel?.text = person.name
        detailTextLabel?.text = person.phone
    }
}
