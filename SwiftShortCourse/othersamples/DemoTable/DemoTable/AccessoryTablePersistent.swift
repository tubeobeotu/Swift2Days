//
//  AccessoryTablePersistent.swift
//  DemoTable
//
//  Created by cuong minh on 2/25/15.
//  Copyright (c) 2015 Techmaster. All rights reserved.
//

import UIKit

class AccessoryTablePersistent: UITableViewController {
    var data : NSMutableArray!
    var path : NSString!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Copy đoạn code kiểm tra data.plist đã có ở thu mục document chưa
        //Nếu chưa có thì copy từ main bundle vào, rồi đọc ra.
        //http://stackoverflow.com/questions/25100262/save-data-to-plist-file-in-swift
 
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = paths.stringByAppendingPathComponent("TableData.plist")
        var fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(path) as (String)))
        {
            var bundle : NSString = NSBundle.mainBundle().pathForResource("TableData", ofType: "plist")!
            fileManager.copyItemAtPath(bundle, toPath: path, error:nil)
        }
        //Nạp dữ liệu vào data
        data = NSMutableArray(contentsOfFile: path as String)!

    }
    
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func viewWillDisappear(animated: Bool) {
        //Lưu data từ memory vào data.plist trong thư mục document ở đây !
        data.writeToFile(path as String, atomically: true)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let cellID  = "#"
        if let dequeCell = tableView.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell! {
            cell = dequeCell
        } else  {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
        }
        let item = data[indexPath.row] as! NSDictionary
        cell.textLabel?.text = item["text"] as? String
        
        //2. khởi tạo custom accessoryView
        let accessoryView = CustomCheck(noncheck: UIImage(named: "circle")!, check: UIImage(named: "circlecheck")!)
        accessoryView.checked = item["checked"] as Bool
        
        
        //3. hứng tương tác đa chạm
        accessoryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onAccessoryTap:"))
        
        //4. gán vào UITableViewCell.accessoryView
        cell.accessoryView = accessoryView
        
        return cell
    }
    func toogleCheck (indexPath: NSIndexPath) {
        //Cập nhật dữ liệu vào data: NSMutableArray
        let item = data[indexPath.row] as! NSMutableDictionary
        item["checked"] = !(item["checked"] as Bool)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            (cell.accessoryView as CustomCheck).checked = item["checked"] as Bool
        }
        print("\(data)")
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        toogleCheck(indexPath)
    }
    
    func onAccessoryTap(tap: UITapGestureRecognizer) {
        let tapPosition = tap.locationInView(self.tableView)
        // Lookup the index path of the cell whose checkbox was modified.
        if let indexPath = self.tableView.indexPathForRowAtPoint(tapPosition) {
            //println("\(indexPath.row)")
            toogleCheck(indexPath)
        }
    }

}
