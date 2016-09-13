//
//  PlainTable.swift
//  DemoTable
//
//  Created by cuong minh on 11/4/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import UIKit

class PlainTable: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
    }
    var data = ["Banana", "Orange", "Lemon"]
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("id", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Table is selected at \(indexPath.row) - \(data[indexPath.row])")
    }
    
}
