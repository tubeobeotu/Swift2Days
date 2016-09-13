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
            Menu(title: "Plain Table", viewClass: "PlainTable"),
            Menu(title: "Raw Table", viewClass: "RawTableViewVC"),
            Menu(title: "Group Table", viewClass: "GroupTable"),
            Menu(title: "2 Tables in VC", viewClass: "TwoTableViewsInVC"),
            Menu(title: "Table + Photo", viewClass: "VictoriaSecret"),
            Menu(title: "Index Table", viewClass: "IndexTable"),
            Menu(title: "Table StoryBoard", viewClass: "TableStoryBoard", storyBoard: "Storyboard", storyBoardID: "TableStoryBoard")
            ])
        let medium = MenuSection(section: "Intermediate", menus:[
            Menu(title: "Accessory Table", viewClass: "AccessoryTable"),
            Menu(title: "Setting Table", viewClass: "SettingTable"),
            Menu(title: "Multi Seclection", viewClass: "MultiSelection"),
            Menu(title: "Custom Cell", viewClass: "CustomCellDemo"),
            Menu(title: "Search", viewClass: "SearchTable"),
            Menu(title: "CRUD", viewClass: "StudentListVC")
            ])
        
        let advanced = MenuSection(section: "Avanced", menus:[
            Menu(title: "Custom Draw Cell", viewClass: "CustomDrawCell"),
            Menu(title: "RezingHeightCell", viewClass: "RezingHeightCell"),
            Menu(title: "LazyLoading", viewClass: "LazyLoading"),
            Menu(title: "CachingImage", viewClass: "CachingImage"),
            Menu(title: "PullingToRefresh", viewClass: "PullingToRefresh")
            ])
        
        let collectionView = MenuSection(section: "UICollectionView", menus:[
            Menu(title: "CustomLayout", viewClass: "UICollectionViewCustomLayout")
            ])
        
        let mainScreen = MainScreen(style: UITableViewStyle.Grouped)
        mainScreen.menu = [basic, medium, advanced, collectionView]
        mainScreen.title = "UITableView"
        mainScreen.about = "Techmaster"
        
        let nav = UINavigationController(rootViewController: mainScreen)
        
        window.rootViewController = nav
        
    }
}
