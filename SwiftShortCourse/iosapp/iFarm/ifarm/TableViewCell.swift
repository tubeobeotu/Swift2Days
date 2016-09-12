//
//  TableViewCell.swift
//  TableCell
//
//  Created by HoangHai on 8/31/16.
//  Copyright © 2016 CanhDang. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_sensorCode: UILabel!
    
    @IBOutlet weak var lbl_temperature: UILabel!
    
    @IBOutlet weak var lbl_pH: UILabel!
    
    @IBOutlet weak var lbl_battery: UILabel!
    
    @IBOutlet weak var lbl_humidity: UILabel!
    
    var cellFrame: CGRect! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    //Tạo ô cell theo cellFrame sẽ truyền ở ViewController, cellForRowAtIndexPath
    override func layoutSubviews() {
        super.layoutSubviews()
        var cellRect = bounds
        cellRect.size.width = self.cellFrame.size.width
        cellRect.size.height = self.cellFrame.size.height
        self.bounds = cellRect
        
        setupContentView(self.cellFrame.size, borderColor: UIColor.baseColor().CGColor, cornerRadius: 10, borderWidth: 2)
        
    }
    
    //Hàm này bo góc, co lại khung contentView
    func setupContentView(size: CGSize, borderColor: CGColor, cornerRadius: CGFloat, borderWidth: CGFloat) {
        
        contentView.frame.size = size
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.borderColor = borderColor
        contentView.layer.borderWidth = borderWidth
    }
    
    // Đổ dữ liệu lên viewCell
    func configure(sensor: Sensor) {
        lbl_sensorCode.text = sensor.id
        
        print(sensor.id)
        
        if let temperature = sensor.sensorData?.temperature {
            lbl_temperature.text = String(format: "%.1f", temperature) + " C"
        } else {
            lbl_temperature.text = "??? C"
        }
        
        if let pH = sensor.sensorData?.pH {
            lbl_pH.text = String(format: "%.1f", pH) + " pH"
        } else {
            lbl_pH.text = "??? pH"
        }
        
        if let battery = sensor.sensorData?.battery {
            lbl_battery.text = String(format: "%.1f", battery) + " %"
        }
        
        if let moisture = sensor.sensorData?.moisture {
            lbl_humidity.text = String(format: "%.1f", moisture) + " %"
        }
        
    }
    
}
