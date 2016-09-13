//
//  SearchResultController.swift
//  DemoTable
//
//  Created by cuong minh on 11/18/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import UIKit

class SearchResultController: AnimalVC {
    var searchText: String? //Lưu chuỗi cần tìm kiếm
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("id", forIndexPath: indexPath)
        
        //Lấy ra từng phần tử của mảng kết quả trả về
        let animal = animals[indexPath.row]
        
        if let searchStr = searchText {
            //NSMutableAttributedString là chuỗi có thể định dạng hiển thị: màu chữ, màu nền, font chữ, kích thước, bold, italic, underline, stroke...
            let attributedText = NSMutableAttributedString(string: animal)

            let range = (animal as NSString).rangeOfString(searchStr, options: NSStringCompareOptions.CaseInsensitiveSearch)

            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)

            cell.textLabel?.attributedText = attributedText
            
        } else {
            cell.textLabel?.text = animal
        }
        cell.imageView?.image = UIImage(named: getImageFileName(animal))
        return cell
    }

}
