//
//  Nguoi+CoreDataProperties.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/12/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Nguoi {

    @NSManaged var name: String?
    @NSManaged var gender: Int16
    @NSManaged var dob: NSDate?  //Sử dụng NSDate sẽ dễ tạo dữ liệu
    @NSManaged var salary: Int32
    @NSManaged var coMotViecLam: NSManagedObject?

}
