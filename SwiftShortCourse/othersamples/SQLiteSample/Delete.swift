//
//  Delete.swift
//  SQLiteSample
//
//  Created by Tuuu on 9/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
class Delete: ConsoleScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        let manageDataBase = ManageDataBase.sharedInstance
        let idToDelete:Int64 = 1
        let table = "DetailFarms"
        do
        {
            let result = try manageDataBase.deleteRow(table, id: idToDelete)
            writeln(result)
        }
        catch
        {
            writeln("Không xoá được nhân viên có ID là 5 trong bảng \(table)")
        }
    }
}