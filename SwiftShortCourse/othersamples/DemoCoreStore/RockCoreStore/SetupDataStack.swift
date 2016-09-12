//
//  SetupDataStack.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/10/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import CoreStore
import SwiftDate

class SetupDataStack: ConsoleScreen {

    let dataStack = DataStack(modelName: "HumanResource")
    
    func configureStorage() {
        let sqliteStore = SQLiteStore(
            fileName: "HumanResource.sql",
            configuration: "Default",
            localStorageOptions: .RecreateStoreOnModelMismatch)
        
        
        
        _ = dataStack.addStorage(
            sqliteStore,
            completion: { (result) in
                switch result {
                case .Success(_):
                   // print("Successfully added sqlite store: \(storage)")
                    self.addSampleData()
                    self.getData()
                    self.writeln("Set up done")
                    
                case .Failure(let error):
                    print("Failed adding sqlite store with error: \(error)")
                }
        })
        
        CoreStore.defaultStack = dataStack
        
    }
    
    func addSampleData() {
        dataStack.beginSynchronous { transaction in
            
            transaction.deleteAll(From(Person))
            
            let person1 = transaction.create(Into<Person>())
            person1.name = "Cuong"
            person1.gender = 1
            person1.dob = NSDate(year: 1975, month: 11, day: 27)
            
            let person2 = transaction.create(Into<Person>())
            person2.name = "Khue"
            person2.gender = 0
            person2.dob = NSDate(year: 2011, month: 1, day: 11)
            
            
            transaction.commitAndWait()
        }
    }
    
    func getData() {
        if let people = dataStack.fetchAll(From(Person)) {
            for aPerson in people {
                writeln("\(aPerson)")
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureStorage()

        
    }
    

}
