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
        let basic = MenuSection(section: "Basic", menus:[
            Menu(title: "Pan", viewClass: "DemoTap"),
            Menu(title: "Rotate", viewClass: "DemoRotate"),
            Menu(title: "Swipe", viewClass: "DemoSwipe"),
            Menu(title: "Pinch", viewClass: "DemoPinch"),
            Menu(title: "Pinch Rotate", viewClass: "DemoPinchRotate"),
            Menu(title: "Throw Ball", viewClass: "ThrowBall"),
            Menu(title: "Ambiguity", viewClass: "Ambiguity")
            ])

        
        let mainScreen = MainScreen(style: UITableViewStyle.Grouped)
        mainScreen.menu = [basic]
        mainScreen.title = "Gesture Recognizer"
        mainScreen.about = "Gesture Recognizer written by Cuong"
        
        let nav = UINavigationController(rootViewController: mainScreen)
        
        window.rootViewController = nav        
      
    }   
}
