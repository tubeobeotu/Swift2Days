//
//  UpdateTable.swift
//  SQLiteSample
//
//  Created by Tuuu on 9/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
class Update: ConsoleScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        do
        {
            let manageDataBase = ManageDataBase.sharedInstance
            let result = try manageDataBase.updateRow(4)
            writeln(result)
        }
        catch
        {
            writeln("Gặp lỗi khi cập nhật dữ liệu vào bảng employee")
        }
    }
}