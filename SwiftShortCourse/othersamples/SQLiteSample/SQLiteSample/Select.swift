//
//  SelectTable.swift
//  SQLiteSample
//
//  Created by Tuuu on 9/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation

class Select: ConsoleScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        let manageDataBase = ManageDataBase.sharedInstance
        do
        {
            let result = try manageDataBase.selectAllValueInTable("DetailFarms")
            writeln(result)
        }
        catch
        {
            writeln("Gặp lỗi khi lấy dữ liệu từ bảng")
        }
    }
}