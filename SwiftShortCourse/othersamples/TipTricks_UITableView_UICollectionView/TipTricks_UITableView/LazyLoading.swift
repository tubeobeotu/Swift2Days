//
//  LazyLoading.swift
//  TipTricks_UITableView
//
//  Created by Tuuu on 9/10/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

class LazyLoading: UITableViewController {
    let imageLinkArray = ["https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQ28l1l13xh-xUXCGK8egiEjZAtUQ88yWEgwoQeQNwj6pPYWK4QMQ",
                          "http://gazettereview.com/wp-content/uploads/2016/06/davidbeckham-700x437.jpg",
                          "http://media.gq.com/photos/56e853e7161e63486d04d6c8/master/pass/david-beckham-gq-0416-2.jpg",
                          "http://media.gq.com/photos/56e867a9239f13cf5b2ba2d8/master/pass/david-beckham-gq-0416-cover-sq.jpg",
                          "https://upload.wikimedia.org/wikipedia/commons/7/71/Tom_Cruise_avp_2014_4.jpg",
                          "http://cdn1.thr.com/sites/default/files/imagecache/portrait_300x450/2012/09/cruise_a_0.jpg",
                          "http://media1.santabanta.com/full1/Global%20Celebrities(M)/Tom%20Cruise/tom-cruise-24a.jpg",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtWIngEIEaCXskv0CAT5XyeT-7C3hlrwMDTsbXN2M3kjcjmUpm3g"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RezingCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 300
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imageLinkArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // try to reuse cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RezingCell
        
        cell.img.image = UIImage(named: "placeholder")  //set placeholder image first.
        cell.img.downloadImageFrom(link: imageLinkArray[indexPath.row], contentMode: .ScaleToFill, completetion: nil)  //set your image from link array.
        
        return cell
        
    }
    
}
