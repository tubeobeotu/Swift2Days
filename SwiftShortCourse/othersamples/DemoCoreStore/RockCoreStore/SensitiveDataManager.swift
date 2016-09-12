//
//  SensitiveDataManager.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/10/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation
import CoreStore

struct Static {
    static let sensitiveDataStack: DataStack = {
        
    let dataStack = DataStack(modelName: "SecretStore")
    
    
    let sqliteStore = SQLiteStore(
            fileName: "SecretStore.sql",
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