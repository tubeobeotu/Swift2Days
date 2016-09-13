//
//  AnimalVC.swift
//  DemoTable
//
//  Created by cuong minh on 11/18/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import UIKit

class AnimalVC: UITableViewController {
    var animals:[String]!
    var detailViewController: DetailViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
    }
    // MARK: - Share functions
    func getImageFileName(animal: String) -> String {
        var imageFileName = animal.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "_")
        imageFileName += ".jpg"
        return imageFileName
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return animals.count
    }

}
