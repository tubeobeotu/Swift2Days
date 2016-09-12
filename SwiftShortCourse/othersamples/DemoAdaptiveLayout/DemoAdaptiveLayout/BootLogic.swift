//
//  BootLogic.swift
//  TechmasterSwiftApp
//  Techmaster Vietnam

import UIKit


struct Menu {
    var title: String
    var viewClass: String  //Xib file must be same name with viewClass
    var storyBoard: String?
    var storyBoardID: String?
    init(title: String, viewClass: String) {
        self.title = title
        self.viewClass = viewClass
        self.storyBoard = nil
        self.storyBoardID = nil
    }
    init(title: String, viewClass: String, storyBoard: String, storyBoardID: String) {
        self.title = title
        self.viewClass = viewClass
        self.storyBoard = storyBoard
        self.storyBoardID = storyBoardID
    }
};

struct MenuSection {
    var section: String
    var menus: [Menu]
}

class BootLogic: NSObject {
    
    var menu : [MenuSection]!
    class func boot(window:UIWindow){
        let basic = MenuSection(section: "Autolayout by UI", menus:[
            Menu(title: "Center a view", viewClass: "CenterView"),
            Menu(title: "Margin", viewClass: "CenterMarginView"),
            Menu(title: "Margin with other objects", viewClass: "MarginWithOther")
            ])

        let intermediate = MenuSection(section: "Autolayout programmatically", menus:[
            Menu(title: "CenterX a view", viewClass: "CenterX"),
            Menu(title: "CenterX-Y a view", viewClass: "CenterAll"),
            Menu(title: "Two view equal width", viewClass: "EqualWidth"),
            Menu(title: "Demo metrics", viewClass: "DemoMetrics"),
            Menu(title: "Demo options", viewClass: "DemoOptions"),
            Menu(title: "Multipler constraint", viewClass: "DemoMultipler"),
            Menu(title: "Four Squares", viewClass: "FourSquares"),
            Menu(title: "Update constraint on rotation", viewClass: "UpdateConstrainOnRotation"),
            Menu(title: "IntrinsicContentSize", viewClass: "DemoIntrinsicContentSize"),
            Menu(title: "Modify constraint on fly", viewClass: "ModifyConstraint")
            ])
        
        let mainScreen = MainScreen(style: UITableViewStyle.Grouped)
        mainScreen.menu = [basic, intermediate]
        mainScreen.title = "CoreStore"
        mainScreen.about = "Demo CoreStore written by Cuong"
        
        let nav = UINavigationController(rootViewController: mainScreen)
        
        window.rootViewController = nav        
      
    }   
}
