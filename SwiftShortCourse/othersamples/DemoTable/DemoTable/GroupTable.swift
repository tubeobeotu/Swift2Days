//
//  GroupTable.swift
//  DemoTable
//
//  Created by cuong minh on 11/4/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import UIKit

class GroupTable: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = Array<DataItem>()
    
    var tableView: UITableView?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        data.append(DataItem(title: "Fruits", data: ["Orange", "Lemon", "Banana", "Black Berry"]))
        data.append(DataItem(title: "Things", data:["Clock", "Watch", "Tivi"]))
        data.append(DataItem(title: "Girls", data:["Miranda Kerr", "Kate Upton", "Adriana Lima", "Rosie Huntington-Whiteley"]))
        
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView!)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
        
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dataItem = data[section] as DataItem
        return dataItem.data.count
    }
    
    
    ////
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("id", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        let dataItem = data[indexPath.section] as DataItem
        cell.textLabel?.text = dataItem.data[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dataItem = data[section] as DataItem
        return dataItem.title
    }
    
    
}
