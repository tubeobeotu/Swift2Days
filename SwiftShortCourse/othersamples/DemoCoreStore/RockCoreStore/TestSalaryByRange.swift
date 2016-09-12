//
//  TestSalaryByRange.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/11/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import CoreStore
class TestSalaryByRange: ConsoleScreen {

    var employees: [Employee]?
    var countryEmployees = [String: [Employee]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        queryBySalary(200, toSal: 20000)
        
    }
    
    func queryBySalary(fromSal: Int, toSal: Int) {
        employees = HumanResource.dataStack.fetchAll(From(Employee),
                                                     Where("salary >= %d", fromSal) && Where("salary <= %d", toSal),
                                                        OrderBy(.Ascending("language"), .Descending("salary")))
        
        var language = ""
        
        //var employeeHasSameLanguage:[Employee]
        for employee in employees! {
            print("\(employee.language!) - \(employee.name!) - \(employee.salary)")
            
            
            if language != employee.language! {
                language = employee.language!
                countryEmployees[language] = [employee] //employeeHasSameLanguage  //Gán mảng các nhân viên chung ngôn ngữ
            } else {
                countryEmployees[language]!.append(employee)
            }
            
        }
        //print (countryEmployees.count)
    }

}
