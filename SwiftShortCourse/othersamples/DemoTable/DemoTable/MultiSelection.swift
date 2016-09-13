//
//  MultiSelection.swift
//  DemoTable
//
//  Created by cuong minh on 11/7/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import UIKit

class MultiSelection: UITableViewController {

    var data : NSMutableArray!
    var deleteButton : UIBarButtonItem?
    var backBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "#")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MultiSelection.onEdit))
        
        deleteButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MultiSelection.onDelete))
        //Lưu tam nút back bar button item
        backBarButtonItem = self.navigationItem.leftBarButtonItem
        
        //Dòng này cực quan trọng, nó cho phép bật chế độ multiple selection
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        data = NSMutableArray(capacity: 20)
        for _ in 0..<20 {
            data.addObject(Person())
        }
    }
    
    func onEdit() {
        if self.tableView.editing {
            self.tableView.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem = backBarButtonItem
        } else {
            self.tableView.setEditing(true, animated: true)
            self.navigationItem.leftBarButtonItem = deleteButton
        }
    }
    
    func onDelete() {
        if let selectedRows = self.tableView.indexPathsForSelectedRows {
            if selectedRows.count > 0 {
                let indicesOfItemsToDelete = NSMutableIndexSet()
                for selectedIndex in selectedRows {
                    indicesOfItemsToDelete.addIndex(selectedIndex.row)
                }
                data.removeObjectsAtIndexes(indicesOfItemsToDelete)
                self.tableView.deleteRowsAtIndexPaths(selectedRows, withRowAnimation: UITableViewRowAnimation.Automatic)
            }            
        }
        
    }


    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("#", forIndexPath: indexPath)
        
        let person = data[indexPath.row] as! Person
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = "\(person.age)"

        return cell
    }


}
