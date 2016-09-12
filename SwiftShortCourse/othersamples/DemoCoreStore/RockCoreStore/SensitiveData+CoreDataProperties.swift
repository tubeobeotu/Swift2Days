//
//  SensitiveData+CoreDataProperties.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/10/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SensitiveData {

    @NSManaged var id: String?
    @NSManaged var hashcode: String?

}
