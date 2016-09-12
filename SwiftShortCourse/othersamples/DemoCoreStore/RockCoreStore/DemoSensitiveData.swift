//
//  DemoSensitiveData.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/10/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//
import CoreStore
import SwiftDate

class DemoSensitiveData: ConsoleScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Static.sensitiveDataStack.beginSynchronous { transaction in
            
            transaction.deleteAll(From(SensitiveData))
            
            let data1 = transaction.create(Into<SensitiveData>())
            data1.id = "oq38y423784"
            data1.hashcode="q34u23089493-248"
            
            
            let data2 = transaction.create(Into<SensitiveData>())
            data2.id = "lakhdfoas9082347"
            data2.hashcode="ewfjhuy239423"
            
            
            transaction.commitAndWait()
            self.writeln("Sensitive written successfully")
            
        }
        
        if let data1 = Static.sensitiveDataStack.fetchOne(From(SensitiveData)) {
            self.writeln("\(data1.id!) -- \(data1.hashcode!)")
        }

    }
}
