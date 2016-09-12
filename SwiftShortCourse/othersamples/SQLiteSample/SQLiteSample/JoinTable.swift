//
//  JoinTable.swift
//  SQLiteSample
//
//  Created by Tuuu on 9/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
class JoinTable: ConsoleScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        let manageDataBase = ManageDataBase.sharedInstance
        do
        {
            let result = try manageDataBase.joinTable()
            write(result)
        }
        catch
        {
            write("Gặp lỗi khi join giữa các bảng")
        }
        

    }
}