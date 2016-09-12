//
//  CustomDrawCell.swift
//  DemoTable
//
//  Created by cuong minh on 2/26/15.
//  Copyright (c) 2015 Techmaster. All rights reserved.
//

import UIKit

class CustomDrawCell: UITableViewController {
    var data = NSMutableArray()
    let STOCK = "STOCK"
    let VALUES = "VALUES"
    let DAYS = 9
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }

    func initData() {
        let stockKeys = ["Apple", "Microsoft", "Google", "FaceBook", "Tesla"]
        for stockKey in stockKeys {
            let stock = NSMutableDictionary()
            stock.setObject(stockKey, forKey: STOCK)
            stock.setObject(generateStockValue(DAYS), forKey: VALUES)
            data.addObject(stock)
        }
    }
    func generateStockValue(day: Int) -> [Float] {
        var stockValues = [Float]()
        for _ in 1...day {
            stockValues.append(Float(arc4random_uniform(80)))
        }
        return stockValues
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "id"
        var cell: UITableViewCell
        if let dequeCell: AnyObject = tableView.dequeueReusableCellWithIdentifier(cellID) {
            cell = dequeCell as! UITableViewCell
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
        }
        let stock = data[indexPath.row] as! NSDictionary
        cell.textLabel?.text = stock[STOCK] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let stock = data[indexPath.row] as! NSDictionary
        let chartView = ChartLayer()
        chartView.initWithData(stock[VALUES] as NSArray, andFrame: cell.bounds)
       /* let textLayer = CATextLayer()
        textLayer.string = stock[STOCK]
        textLayer.bounds = CGRect(x: 0, y: 0, width: 200, height: 30)
        textLayer.font =   UIFont.boldSystemFontOfSize(12)//[UIFont boldSystemFontOfSize:18].fontName
        //textLayer.fontSize = 12
        textLayer.backgroundColor = UIColor.clearColor().CGColor
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.position = CGPointMake(100, 15)
        textLayer.wrapped = false

        cell.layer.addSublayer(textLayer)*/
        cell.layer.addSublayer(chartView)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
}
