//
//  ManageDataBase.swift
//  SQLiteSample
//
//  Created by Tuuu on 9/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import SQLite
class ManageDataBase: NSObject {
    
    static let sharedInstance = ManageDataBase()
    
    private override init() {
        
    }
    
    let path = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true
        ).first!
    var db:Connection! = nil
    func checkConnect() -> String
    {
        if (db == nil)
        {
            return "Bạn cần kết nối trước"
        }
        return ""
    }
    func connectToDataBase() throws
    {
        db = try Connection("\(path)/ifarm.sqlite3")
        print(path)
        try db.execute("PRAGMA foreign_keys = ON;")
        db.trace { (info) in
            print(info)
        }
        
    }
    func createTable() throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        let employees = Table("Employees")
        let emploteeId = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        
        UIStackView
        
        let farms = Table("Farms")
        let farmId = Expression<Int64>("id")
        let farmName = Expression<String?>("name")
        
        let detailFarms = Table("DetailFarms")
        let employee = Expression<Int64>("employee")
        let farm = Expression<Int64>("farm")
        
        try db.run(employees.create { t in
            t.column(emploteeId, primaryKey: true)
            t.column(name)
            t.column(email, unique: true)
            })
        // CREATE TABLE "employees" (
        //     "emploteeId" INTEGER PRIMARY KEY NOT NULL,
        //     "name" TEXT,
        //     "email" TEXT NOT NULL UNIQUE
        // )
        try db.run(farms.create(block: { (t) in
            t.column(farmId, primaryKey: true)
            t.column(farmName)
            
        }))
        try db.run(detailFarms.create(block: { (t) in
            t.column(farm, references: farms, farmId)
            t.column(employee, references: employees, emploteeId)
            t.primaryKey(employee, farm)
        }))
        return "Tạo các bảng thành công"
        
    }
    func insertValues() throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        let employees = Table("Employees")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        for i in 0 ... 100
        {
            let insertValue = employees.insert(name <- "techmaster\(i)", email <- "email\(i).com")
            // INSERT INTO "Employees" ("name", "email") VALUES ('techmaster', 'email@mac.com')
            try db.run(insertValue)
        }
        
        let farms = Table("Farms")
        let farmName = Expression<String?>("name")
        
        for i in 0 ... 100
        {
            let insertValue = farms.insert(farmName <- "ChuongNuoiBo\(i)")
            // INSERT INTO "Farms" ("farmName") VALUES ('ChuongNuoiBo')
            try db.run(insertValue)
        }
        
        let detailFarms = Table("DetailFarms")
        let employee = Expression<Int64>("employee")
        let farm = Expression<Int64>("farm")
        
        for farmID in 1 ... 5
        {
            for employeeID in 1 ... 2
            {
                let insertValue = detailFarms.insert(farm <- Int64(farmID), employee <- Int64(employeeID))
                // INSERT INTO "DetailFarms" ("employee", "farm") VALUES (farmID, employeeID)
                
                try db.run(insertValue)
                
            }
        }
        return "Chèn thành công"
    }
    func deleteRow(tableName: String, id: Int64) throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        let table = Table(tableName)
        let idToDelete = Expression<Int64>("farm")
        let userToDelete = table.filter(idToDelete == id)
        
        try db.run(userToDelete.delete())
        return "Xoá thành công"
        
    }
    func dropTable(tableName: String) throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        let table = Table(tableName)
        try db.run(table.drop(ifExists: true))
        return ""
        
    }
    func updateRow(id: Int64) throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        let employees = Table("Employees")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        
        let idToUpdate = Expression<Int64>("id")
        let employee = employees.filter(idToUpdate == id)
        
        try db.run(employee.update([email <- email.replace("com", with: "techmaster"), name <- "Nguyen Van Tu"]))
        // UPDATE "Employees" SET "email" = replace("email", 'mac.com', 'me.com'), name = "Nguyen Van Tu"
        // WHERE ("id" = 1)
        
        return "Cập nhật thành công"
        
    }
    func selectAllValueInTable(tableName: String) throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        var result = ""
        let table = Table(tableName)
        
        for user in try db.prepare(table) {
            for value in user.getAllValues()
            {
                result = result + value
            }
            result = result + "\n"
        }
        // SELECT * FROM "users"
        
        return result
        
        
    }
    func selectWithColumns() throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        var result = ""
        //selecting columns
        let table = Table("Employees")
        let id = Expression<Int64>("id")
        let email = Expression<String>("email")
        
        for user in try db.prepare(table.select(id, email))
        {
            result = result + String(user[id])
        }
        
        
        //Plucking Rows
        //        if let user = try db.pluck(table)
        //        {
        //
        //        }
        // SELECT * FROM "users" LIMIT 1
        
        return result
    }
    func selectWithQuery(query: QueryType) throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        var result = ""
        for user in try db.prepare(query) {
            for value in user.getAllValues()
            {
                result = result + value
            }
            result = result + "\n"
        }
        return result
    }
    
    func filterRow() throws -> String
    {
        let employees = Table("Employees")
        let id = Expression<Int64>("id")
        let email = Expression<String>("email")
        let name = Expression<String>("name")
//        return try selectWithQuery(employees.filter(id == 1))
//        return try selectWithQuery(employees.filter([1, 2, 3, 4, 5].contains(id)))
        return try selectWithQuery(employees.filter(name.like("%Van%")))
//        return try selectWithQuery(employees.filter(id == 1 || email.lowercaseString == "email9.com"))
//
    }
    
    
    func queries() throws -> String
    {
        
        let table = Table("Employees")
        let name = Expression<String?>("name")
        let id = Expression<Int64>("id")
        let query = table.select(name).filter(name != nil).order(id.desc).limit(5, offset: 10)
        
        return try selectWithQuery(query)
    }
    
    func joinTable()throws -> String
    {
        let employees = Table("Employees")
        let employeeId = Expression<Int64>("id")
        let emploteeName = Expression<String?>("name")
        
        let detailFarms = Table("DetailFarms")
        let detailEmployeeId = Expression<Int64>("employee")
        let detailFarmID = Expression<Int64>("farm")
        
        let farms = Table("Farms")
        let farmId = Expression<Int64>("id")
        
        
        let allData = employees.join(detailFarms, on: employees[employeeId] == detailFarms[detailEmployeeId]).join(farms, on: detailFarms[detailFarmID] == farms[farmId]).filter(farms[farmId] == 1)
        return try selectWithQuery(allData.select(employees[emploteeName]))
    }
    
    func transaction() throws -> String
    {
        if (checkConnect() != "")
        {
            return checkConnect()
        }
        let detailFarms = Table("DetailFarms")
        let employeeID = Expression<Int64>("employee")
        let farm = Expression<Int64>("farm")
        
        try db.transaction {
            try self.db.run(detailFarms.insert(farm <- 6, employeeID <- 3))
            try self.db.run(detailFarms.insert(farm <- 6, employeeID <- 3))
        }
        return "thành công"
    }
}