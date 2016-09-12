//
//  DetailFarm.swift
//  iFram
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

class DetailFarm: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView = UITableView()
    var sensors = [Sensor]()
    var rowHeight: CGFloat = 150
    var farm: Farm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        addData()
        
        navigationItem.title = farm.title
        
    }
    func addTableView()
    {
        self.tableView = UITableView(frame: CGRectMake(100, 160, 100, 100))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        let layoutHeight = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutY = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutX = NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let layoutWidth = NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
    }
    func addData()
    {
        
        activeActivityIndicator()
        
        router.getSensorWithFarmID(farm.id, success: { (data) in
            self.sensors = data as! [Sensor]
            
            self.tableView.reloadData()
            
            self.deActiveIndicator()
         }) { (error) in
            
            self.deActiveIndicator()
            
            self.alertView("Warning", message: error.localizedDescription, titleAction: "Ok", completionHandle: nil)
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sensors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        //set khung cellFrame để truyền sang tableViewCell
        cell.cellFrame = CGRectMake(10,10, tableView.frame.width - 20, rowHeight - 10)
        
        //truyền dữ liệu sensor sang tableViewCell
        let sensor = sensors[indexPath.row]
        cell.configure(sensor)
        print(sensor)
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chartVC = ChartViewController(nibName: "ChartViewController", bundle: nil)
        
        navigationController?.pushViewController(chartVC, animated: true)
    }
}
