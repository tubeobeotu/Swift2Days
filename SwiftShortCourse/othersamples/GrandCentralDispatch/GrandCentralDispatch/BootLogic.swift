//
//  BootLogic.swift
//  TechmasterSwiftApp
//  Techmaster Vietnam

import UIKit


struct Menu {
    var title: String
    var viewClass: String
}

struct MenuSection {
    var section: String
    var menus: [Menu]
}

class BootLogic: NSObject {
    
    var menu : [MenuSection]!
    class func boot(window:UIWindow){
        let basic = MenuSection(section: "Basic", menus:[
            Menu(title: "Sync vs Async", viewClass: "SyncVsAsync"),
            Menu(title: "Resize big photo", viewClass: "ResizePhoto"),
            Menu(title: "Serial vs Concurrent Queue", viewClass: "SerialVsConcurrent")
            ])

        let inter = MenuSection(section: "Intermediate", menus:[
            Menu(title: "Group Async", viewClass: "GroupAsync"),
            Menu(title: "Dispatch Once", viewClass: "DispatchOnce"),
            Menu(title: "Dispatch Barrier", viewClass: "DispatchBarrier"),
            Menu(title: "Dispatch After", viewClass: "DispatchAfter"),
            Menu(title: "Dispatch Apply", viewClass: "DispatchApply")
            ])
        
        let advance = MenuSection(section: "Advance", menus:[
            Menu(title: "Semaphore Wait", viewClass: "SemaphoreWait"),
            Menu(title: "Dead Lock", viewClass: "DeadLock"),
            Menu(title: "Toilet Simulation", viewClass: "ToiletSemaphore"),
            Menu(title: "Unsynchronize", viewClass: "Unsynchronize"),
            Menu(title: "Synchronize", viewClass: "SynchronizeDemo")
            ])
        
        let mainScreen = MainScreen(style: UITableViewStyle.Grouped)
        mainScreen.menu = [basic, inter, advance]
        mainScreen.title = "Grand Central Dispatch"
        mainScreen.about = "Written by Trinh Minh Cuong"
        
        let nav = UINavigationController(rootViewController: mainScreen)
        //nav.navigationBar.barStyle = UIBarStyle.BlackOpaque
        //nav.navigationBar.opaque = true
        window.rootViewController = nav        
      
    }   
}
