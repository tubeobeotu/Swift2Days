//
//  Query.swift
//  SQLiteSample
//
//  Created by Tuuu on 9/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
class Query: ConsoleScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        let manageDataBase = ManageDataBase.sharedInstance
        do
        {
            let result = try manageDataBase.queries()
            write(result)
        }
        catch
        {
            write("Gặp lỗi khi tạo query")
        }
    }
}