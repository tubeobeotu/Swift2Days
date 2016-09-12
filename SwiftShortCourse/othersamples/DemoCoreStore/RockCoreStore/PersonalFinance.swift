//
//  PersonalFinance.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/12/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation
import CoreStore
//Đây là thư viện để kết nối vào SQLite file PersonalFinance.sql, ánh xạ với model (schema) PersonalFinance
struct PersonalFinance {
    static let dataStack: DataStack = {
        
        let dataStack = DataStack(modelName: "PersonalFinance")
        
        
        let sqliteStore = SQLiteStore(
            fileName: "PersonalFinance.sql",
            localStorageOptions:.RecreateStoreOnModelMismatch)
        
        
        do {
            try dataStack.addStorageAndWait(sqliteStore)
        } catch (let error) {
            print("Failed adding sqlite store with error: \(error)")
        }
        return dataStack
        
    }()
    
}