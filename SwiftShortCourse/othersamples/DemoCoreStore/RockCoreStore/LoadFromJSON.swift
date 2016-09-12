//
//  LoadFromJSON.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/11/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import CoreStore
import JASON
import SwiftDate
import Kingfisher

class LoadFromJSON: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    internal var employeeJSON: [JSON]? = nil
    
    var employees: [Employee]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.tableView.allowsMultipleSelectionDuringEditing = false
        loadDataFromJSON(saveComplete)
 
    }
    
    func loadDataFromJSON(completion: (result: SaveResult) -> Void = { _ in }) {
        
        dispatch_async(queue) {
            if let path = NSBundle.mainBundle().pathForResource("employee", ofType: "json")
            {
                if let jsonData = NSData(contentsOfFile: path) {
                    self.employeeJSON =  JSON(jsonData).jsonArray
                }
            }
            
            //if self.employeeJSON == nil { return }
            guard self.employeeJSON != nil else { return }
            
            HumanResource.dataStack.beginAsynchronous { transaction in
                transaction.deleteAll(From(Employee))
                var i = 0
                let floatCount: Float = Float(self.employeeJSON!.count)
                
                for emp in self.employeeJSON! {
                    
                    let employee = transaction.create(Into<Employee>())
                    if let name = emp["name"].string { employee.name = name }
                    
                    if let gender = emp["gender"].int { employee.gender = Int16(gender) }
                    
                    
                    if let dob = emp["dob"].string {
                        employee.dob = dob.toDate(DateFormat.Custom("dd/MM/yyyy"))
                    }
                    
                    if let photo = emp["photo"].string { employee.photo = photo }
                    
                    if let company = emp["company"].string {employee.company = company}
                    
                    if let language = emp["language"].string { employee.language = language }
                    
                    if let longitude = emp["longitude"].double { employee.longitude = longitude }
                    
                    if let latitude = emp["latitude"].double { employee.latitude = latitude }
                    
                    if let salary = emp["salary"].int { employee.salary = Int32(salary) }
                    
                    i += 1
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.progressView.progress = Float(i) / floatCount
                    })
                }
                
               //try! transaction.importObjects(Into<Employee>(), sourceArray: self.employeeJSON)
                
                transaction.commit(completion)
                
            }
        }
    }
    
    func saveComplete (result: SaveResult)  {
        employees = HumanResource.dataStack.fetchAll(From<Employee>())
        self.tableView.reloadData()
        
    }
}


//MARK: UITableViewDataSource
extension LoadFromJSON: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if employees != nil {
            return (employees?.count)!
        } else {
            return 0
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PersonCell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell        
       
        
        let employee: Employee = employees![indexPath.row]
        cell.name.text = employee.name
        
        if let dob = employee.dob {
            cell.dob.text = dob.toString(DateFormat.Custom("YYYY-MM-dd"))!
        } else {
            cell.dob.text = ""
        }
        
        switch employee.gender {
        case 0:
            cell.gender.text = "female"
        case 1:
            cell.gender.text = "male"
        default:
            cell.gender.text = "+/-"
        }
   
        if let photo = employee.photo {
            cell.photo.kf_setImageWithURL(NSURL(string: photo)!)
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
}
//MARK: UITableViewDelegate
extension LoadFromJSON: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    //Cho phép swipe to edit hoặc delete
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    //Xóa dòng
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            HumanResource.dataStack.beginAsynchronous { transaction in
                
                let employee: Employee = self.employees![indexPath.row]
                transaction.delete(employee)
                
                transaction.commit({ (result) in
                    self.employees!.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
                
            }
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}





