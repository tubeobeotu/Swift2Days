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
            Menu(title: "Screen A", viewClass: "ScreenA"),
            Menu(title: "Screen B", viewClass: "ScreenB")
            ])

        let inter = MenuSection(section: "inter", menus:[
            Menu(title: "Rock", viewClass: "DemoTap"),
            Menu(title: "Home", viewClass: "DemoPan")
            ])
        
        let advance = MenuSection(section: "advance", menus:[
            Menu(title: "Rock", viewClass: "DemoTap"),
            Menu(title: "Home", viewClass: "DemoPan")
            ])
        
        let mainScreen = MainScreen(style: UITableViewStyle.Grouped)
        mainScreen.menu = [basic, inter, advance]
        mainScreen.title = "Gesture Recognizer"
        mainScreen.about = "Gesture Recognizer iOS8"
        
        let nav = UINavigationController(rootViewController: mainScreen)
        
        window.rootViewController = nav        
      
    }   
}
