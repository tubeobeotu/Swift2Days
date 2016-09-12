//
//  BootLogic.swift
//  TechmasterSwiftApp
//  Techmaster Vietnam

import UIKit


struct Menu {
    var title: String
    var viewClass: String
};

struct MenuSection {
    var section: String
    var menus: [Menu]
}

class BootLogic: NSObject {
    
    var menu : [MenuSection]!
    class func boot(window:UIWindow){
        let basic = MenuSection(section: "Basic", menus:[
            Menu(title: "ConnectDataBase", viewClass: "ConnectDataBase"),
            Menu(title: "CreateTable", viewClass: "CreateTable"),
            Menu(title: "Insert", viewClass: "Insert"),
            Menu(title: "Select", viewClass: "Select"),
            Menu(title: "Update", viewClass: "Update"),
            Menu(title: "Delete", viewClass: "Delete")
            ])

        let inter = MenuSection(section: "Inter", menus:[
            Menu(title: "JoinTable", viewClass: "JoinTable"),
            Menu(title: "Filter", viewClass: "Filter"),
            Menu(title: "Query", viewClass: "Query")
            ])
        
        let advance = MenuSection(section: "Advance", menus:[
            Menu(title: "Transaction", viewClass: "Transaction")
            ])
        
        let mainScreen = MainScreen(style: UITableViewStyle.Grouped)
        mainScreen.menu = [basic, inter, advance]
        mainScreen.title = "Gesture Recognizer"
        mainScreen.about = "Gesture Recognizer iOS8"
        
        let nav = UINavigationController(rootViewController: mainScreen)
        
        window.rootViewController = nav        
      
    }   
}
