//
//  DataTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/8/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

struct DataTableViewCellData {
    
    init(imageUrl: String, text: String) {
        self.imageUrl = imageUrl
        self.text = text
    }
    var imageUrl: String
    var text: String
}

class DataTableViewCell : UITableViewCell {
    
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataText: UILabel!
    
    override func awakeFromNib() {
        self.dataText?.font = UIFont.systemFontOfSize(18)
        self.dataText?.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.menuColorColor()
    }
 
    class func height() -> CGFloat {
        return 55
    }
    
    func setData(data: Any?) {
        if let data = data as? DataTableViewCellData {
            self.dataImage.image = UIImage(named: data.imageUrl)
            self.dataText.text = data.text
        }
    }
}
