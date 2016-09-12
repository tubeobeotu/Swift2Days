//
//  MenuView.swift
//  iFram
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case Main = 0
    case Alert
    case Farm
    case Sensor
    case LogOut
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class MenuView : BaseViewController, LeftMenuProtocol{
    
    var tableView: UITableView!
    var menus = [DataTableViewCellData(imageUrl: "MonitorFarm", text: "Monitor Farm"),
                 DataTableViewCellData(imageUrl: "ViewAlert", text: "View Alert"),
                 DataTableViewCellData(imageUrl: "ManageFarms", text: "Manage Farms"),
                 DataTableViewCellData(imageUrl: "ManageSensors", text: "Manage Sensors"),
                 DataTableViewCellData(imageUrl: "LogOut", text: "Log Out")]
    
    var monitorFarm: UIViewController!
    var viewAlert: UIViewController!
    var manageFarms: UIViewController!
    var manageSensors: UIViewController!
    var logOut: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImgHeader()
        addTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addItemsForMenu()
    }
    func addItemsForMenu()
    {
        let monitorFarm = MonitorFarm(nibName: "MonitorFarm", bundle: nil)
        self.monitorFarm = UINavigationController(rootViewController: monitorFarm)
        
        let viewAlert = ViewAlert(nibName: "ViewAlert", bundle: nil)
        self.viewAlert = UINavigationController(rootViewController: viewAlert)
        
        let manageFarms = ManageFarms(nibName: "ManageFarms", bundle: nil)
        self.manageFarms = UINavigationController(rootViewController: manageFarms)
        
        let manageSensors = ManageSensors(nibName: "ManageSensors", bundle: nil)
        self.manageSensors = UINavigationController(rootViewController: manageSensors)
        
        let logOut = LogOut(nibName: "LogOut", bundle: nil)
        self.logOut = UINavigationController(rootViewController: logOut)
    }
    func addTableView()
    {
        self.tableView = UITableView(frame: CGRectMake(100, 160, 100, 100))
        self.tableView.registerNib(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.menuColorColor()
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutHeight = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: self.imageHeaderView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutY = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutX = NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let layoutWidth = NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
    }
    func addImgHeader()
    {
        self.imageHeaderView = ImageHeaderView.loadNib()
        
        router.getUserInformation({ (user) in
            let user = user as! User
            self.imageHeaderView.configure(user)
        }) { (error) in
            print(error)
        }
        
        self.imageHeaderView.frame = CGRectMake(100, 160, 100, 100)
        self.view.addSubview(self.imageHeaderView)
        self.imageHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutY = NSLayoutConstraint(item: imageHeaderView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutHeight = NSLayoutConstraint(item: imageHeaderView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 160)
        let layoutX = NSLayoutConstraint(item: imageHeaderView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let layoutWidth = NSLayoutConstraint(item: imageHeaderView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
    }
    
    
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.monitorFarm, close: true)
        case .Alert:
            self.slideMenuController()?.changeMainViewController(self.viewAlert, close: true)
        case .Farm:
            self.slideMenuController()?.changeMainViewController(self.manageFarms, close: true)
        case .Sensor:
            self.slideMenuController()?.changeMainViewController(self.manageSensors, close: true)
        case .LogOut:
            keychain["accessToken"] = nil
            keychain["refreshToken"] = nil
            mainDelegate.resetRootViewController()
        }
    }
}


extension MenuView : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Alert, .Farm, .Sensor, .LogOut:
                return DataTableViewCell.height()
            }
        }
        return 0
    }
}

extension MenuView : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Alert, .Farm, .Sensor, .LogOut:
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DataTableViewCell
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    // add icon footer menu
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.frame.origin.y = 100
        imageView.frame.origin.x = (tableView.frame.size.width - imageView.frame.size.width) / 2.0
        
        footerView.addSubview(imageView)
        
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 200.0
    }
}


extension MenuView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
