//
//  Person.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/10/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation
import CoreData
import SwiftDate

class Person: NSManagedObject {

    override var description: String {
        
        return "\(name!) is born at \(dob!.toString(DateFormat.Custom("YYYY-MM-dd"))!)"
    }

}
