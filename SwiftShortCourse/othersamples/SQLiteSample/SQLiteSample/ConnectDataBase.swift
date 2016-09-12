//
//  ConnectDataBase.swift
//  SQLiteSample
//
//  Created by Tuuu on 9/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation

class ConnectDataBase: ConsoleScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataBase = ManageDataBase.sharedInstance
        do
        {
            try dataBase.connectToDataBase()
            writeln("Kết nối thành công đến cơ sở dữ liệu với đường dẫn \n\(dataBase.path)")
        }
        catch
        {
            writeln("Không thể kết nối đến cơ sở dữ liệu")
        }
    }
}