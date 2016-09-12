//
//  MusicDataManager.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/12/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation
import CoreStore

struct Music {
    static let dataStack: DataStack = {
        
        let dataStack = DataStack(modelName: "Music")
        
        
        let sqliteStore = SQLiteStore(
            fileName: "Music.sql",           
            localStorageOptions: .RecreateStoreOnModelMismatch)
        
        
        do {
            try dataStack.addStorageAndWait(sqliteStore)
        } catch (let error) {
            print("Failed adding sqlite store with error: \(error)")
        }
        return dataStack
        
    }()
    
}