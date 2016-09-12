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
        let tableView = MenuSection(section: "UITableView", menus:[
            Menu(title: "MutipleSelectRows", viewClass: "MutipleSelectRows"),
            Menu(title: "RezingHeightCell", viewClass: "RezingHeightCell"),
            Menu(title: "LazyLoading", viewClass: "LazyLoading"),
            Menu(title: "CachingImage", viewClass: "CachingImage"),
            Menu(title: "PullingToRefresh", viewClass: "PullingToRefresh")
            ])

        let collectionView = MenuSection(section: "UICollectionView", menus:[
            Menu(title: "CustomLayout", viewClass: "UICollectionViewCustomLayout")
            ])
        let mainScreen = MainScreen(style: UITableViewStyle.Grouped)
        mainScreen.menu = [tableView, collectionView]
        mainScreen.title = "TipTricks"
        mainScreen.about = "TechmasterVN"
        
        let nav = UINavigationController(rootViewController: mainScreen)
        
        window.rootViewController = nav        
      
    }   
}
