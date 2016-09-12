//
//  HumanResourceDataManager.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/11/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation
import CoreStore

struct HumanResource {
    static let dataStack: DataStack = {
        
        let dataStack = DataStack(modelName: "HumanResource")
        
        
        let sqliteStore = SQLiteStore(
            fileName: "HumanResource.sql",
            configuration: "Default",
            localStorageOptions: .RecreateStoreOnModelMismatch)
        
        
        do {
            try dataStack.addStorageAndWait(sqliteStore)
        } catch (let error) {
            print("Failed adding sqlite store with error: \(error)")
        }
        return dataStack
        
    }()
    
}