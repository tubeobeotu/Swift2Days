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
/*
 let basic = [SECTION: "Basic",MENU:[
 [TITLE: "Plain Table",CLASS: "PlainTable"],
 [TITLE: "Raw Table",CLASS: "RawTableViewVC"],
 [TITLE: "2 Tables in VC",CLASS: "TwoTableViewsInVC"],
 [TITLE: "Group Table",CLASS: "GroupTable"],
 [TITLE: "Table + Photo",CLASS: "VictoriaSecret"],
 [TITLE: "Index Table",CLASS: "IndexTable"],
 [TITLE: "Table StoryBoard",CLASS: "TableStoryBoard#Storyboard"]
 ]
 ] as NSDictionary
 
 let medium = [SECTION: "Intermediate",MENU:[
 [TITLE: "Accessory Table",CLASS: "AccessoryTable"],
 [TITLE: "Accessory Table Persistent",CLASS: "AccessoryTablePersistent"],
 [TITLE: "Setting Table",CLASS: "SettingTable"],
 [TITLE: "Multi Seclection",CLASS: "MultiSelection"],
 [TITLE: "Custom Cell",CLASS: "CustomCellDemo"],
 [TITLE: "Search",CLASS: "SearchTable"],
 [TITLE: "CRUD",CLASS: "StudentListVC"]
 ]
 ] as NSDictionary
 
 let advanced = [SECTION: "Avanced", MENU: [
 [TITLE: "Custom Draw Cell", CLASS: "CustomDrawCell"],
 [TITLE: "Collection View", CLASS: "DemoCollectionView"]
 ]
 ] as NSDictionary
*/
        let basic = MenuSection(section: "Basic", menus:[
            Menu(title: "Plain Table", viewClass: "RawTableViewVC"),
            Menu(title: "Raw Table", viewClass: "DemoRotate"),
            Menu(title: "2 Tables in VC", viewClass: "TwoTableViewsInVC"),
            Menu(title: "Group Table", viewClass: "GroupTable"),
            Menu(title: "Table + Photo", viewClass: "VictoriaSecret"),
            Menu(title: "Index Table", viewClass: "IndexTable"),
            Menu(title: "Table StoryBoard", viewClass: "TableStoryBoard#Storyboard")
            ])
        
        /*let medium = [SECTION: "Intermediate",MENU:[
            [TITLE: "Accessory Table",CLASS: "AccessoryTable"],
            [TITLE: "Accessory Table Persistent",CLASS: "AccessoryTablePersistent"],
            [TITLE: "Setting Table",CLASS: "SettingTable"],
            [TITLE: "Multi Seclection",CLASS: "MultiSelection"],
            [TITLE: "Custom Cell",CLASS: "CustomCellDemo"],
            [TITLE: "Search",CLASS: "SearchTable"],
            [TITLE: "CRUD",CLASS: "StudentListVC"]
        ]*/
        //let medium = MenuSection()
        

        
        let mainScreen = MainScreen(style: UITableViewStyle.Grouped)
        mainScreen.menu = [basic]
        mainScreen.title = "Gesture Recognizer"
        mainScreen.about = "Gesture Recognizer written by Cuong"
        
        let nav = UINavigationController(rootViewController: mainScreen)
        
        window.rootViewController = nav        
      
    }   
}
