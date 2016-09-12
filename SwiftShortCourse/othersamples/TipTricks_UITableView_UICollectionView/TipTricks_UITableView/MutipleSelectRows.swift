//
//  MutipleSelectRows.swift
//  TipTricks_UITableView
//
//  Created by Tuuu on 9/10/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

class MutipleSelectRows: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
