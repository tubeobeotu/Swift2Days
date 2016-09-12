//
//  Employee+CoreDataProperties.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/11/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Employee {

    @NSManaged var company: String?
    @NSManaged var language: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var photo: String?
    @NSManaged var salary: Int32

}
