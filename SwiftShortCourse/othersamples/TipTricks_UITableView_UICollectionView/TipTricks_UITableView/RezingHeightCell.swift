//
//  RezingHeightCell.swift
//  TipTricks_UITableView
//
//  Created by Tuuu on 9/10/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

class RezingHeightCell: UIViewController {
    
    let imgs = ["0", "1", "2", "3", "4", "5", "6"]
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    func refresh(sender:AnyObject) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RezingCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(RezingHeightCell.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    
}
extension RezingHeightCell: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RezingCell
        cell.img.image = UIImage(named: imgs[indexPath.row])
        return cell
    }
}
