//
//  SalaryByRange.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/11/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import CoreStore
import JASON

class SalaryByRange: UIViewController {

    var employees: [Employee]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func queryBySalary(fromSal: Int, toSal: Int) {
        employees = HumanResource.dataStack.fetchAll(From(Employee), Where("Salary >= %d", fromSal) && Where("Salary <= %d", toSal))
        self.tableView.reloadData()
    }

}

/*
extension SalaryByRange: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    }
}

extension SalaryByRange: UITableViewDelegate {
    
}*/