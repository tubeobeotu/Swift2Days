//
//  PersonalFinanceScreen.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/12/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import CoreStore
import SwiftDate

class PersonalFinanceScreen: ConsoleScreen {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Chèn dữ liệu khi load form
        initPersonalFinanceData(onInitComplete)
    }
    //Nếu đã chèn dữ liệu thành công. Cái này là Swift closure một dạng hàm đặc biệt có khả năng lưu các biến trong stack của hàm gọi nó
    
    func onInitComplete(result: SaveResult) {
        print(result)
        
        if let nhieunguoi = PersonalFinance.dataStack.fetchAll(From<Nguoi>()) {
            nhieunguoi.forEach({ (nguoi) in
                print("\(nguoi.name!)")
            })
        }
    }
    
    
    //Chèn dữ liệu mẫu
    func initPersonalFinanceData(completion: (result: SaveResult) -> Void = { _ in }) {
        //beginAsynchronous sẽ thực thi lệnh mà không block hàm hiện giờ. Do đó phải truyền vào closure  để khi hoàn thành thì call back
        
        PersonalFinance.dataStack.beginAsynchronous { transaction in
            transaction.deleteAll(From<Nguoi>()) // xóa toàn bộ bàn ghi trong bảng Nguoi
            
            //Insert từng bản ghi vào bảng Nguoi
            let nguoiA = transaction.create(Into<Nguoi>())
            nguoiA.name = "Trinh Minh Cuong"
            nguoiA.gender = 1
            nguoiA.dob = NSDate(year: 1975, month: 11, day: 27)
            nguoiA.salary = 100
            
            let nguoiB = transaction.create(Into<Nguoi>())
            nguoiB.name = "Chu Van Thin"
            nguoiB.gender = 1
            nguoiB.dob = NSDate(year: 1988, month: 10, day: 15)
            nguoiB.salary = 150
            
            
            //Lệnh commit sẽ ghi dữ liệu xuống ổ SSD của thiết bị di động
            transaction.commit(completion)
        }
    }

}
