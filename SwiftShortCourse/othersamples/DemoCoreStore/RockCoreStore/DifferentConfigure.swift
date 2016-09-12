//
//  DifferentConfigure.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/10/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import CoreStore

class DifferentConfigure: ConsoleScreen {

    let dataStack = DataStack(modelName: "HumanResource")
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStorage()
        
        
    }
    
    func configureStorage() {
        let sqliteStore = SQLiteStore(
            fileName: "HumanResource.sql",
            configuration: "Premium",
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
            
            transaction.deleteAll(From(Job))
            
            let job1 = transaction.create(Into<Job>())
            job1.name = "Developer"
           
            
            let job2 = transaction.create(Into<Job>())
            job2.name = "Tester"
            
            
            transaction.commitAndWait()
        }
    }
    
    func getData() {
        if let jobs = dataStack.fetchAll(From(Job)) {
            for aJob in jobs {
                writeln("\(aJob.name!)")
            }
        }
        
    }
    

    
}
