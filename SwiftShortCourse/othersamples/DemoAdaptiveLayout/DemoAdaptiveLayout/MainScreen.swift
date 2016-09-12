//
//  MainScreen.swift
//  TechmasterSwiftApp


import UIKit

class MainScreen: UITableViewController {
    var about: String!
    
    var menu: [MenuSection]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButoonItem = UIBarButtonItem(title: "About", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainScreen.onAbout))
        self.navigationItem.rightBarButtonItem = barButoonItem
        
        self.tableView.contentInset = UIEdgeInsetsMake(20,0,0,0)
        
    }
    
    func onAbout(){
        let alert = UIAlertController.init(title: "Info",
                                           message: about,
                                           preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menu.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let menuSection: MenuSection  = self.menu[section]
        let menuArray: [Menu] = menuSection.menus
        
        return menuArray.count
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let menuSection: MenuSection = self.menu[section]
        return menuSection.section
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "id")
        let menuSection: MenuSection = self.menu[indexPath.section]
        let menuItems = menuSection.menus
        let item: Menu = menuItems[indexPath.row]
        cell.textLabel!.text = item.title
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuSection: MenuSection = self.menu[indexPath.section]
        let menuItems = menuSection.menus

        let item: Menu = menuItems[indexPath.row]
        
        
        let xibClass = item.viewClass
        let detailScreen: UIViewController!
        
        if let storyBoard = item.storyBoard {
            let storyboardObject = UIStoryboard(name: storyBoard, bundle: nil)
            detailScreen = storyboardObject.instantiateViewControllerWithIdentifier(item.storyBoardID!)
            detailScreen.title = item.title
            self.navigationController!.pushViewController(detailScreen, animated: true)
        } else {
  
            let appName =  NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
            // check if class exits
            if let aClass = NSClassFromString("\(appName).\(xibClass)") as? UIViewController.Type {
           
                if (NSBundle.mainBundle().pathForResource(xibClass, ofType: "nib") == nil){
                    //if the xib file does not exits
                    detailScreen = aClass.init() as UIViewController
                }else{
                    detailScreen = aClass.init(nibName:xibClass,bundle:nil) as UIViewController
                    
                }
                
                self.navigationController!.pushViewController(detailScreen, animated: true)
                
            } else {
                let alert = UIAlertController.init(title: "Warning",
                                                   message: "Please implement screen \(xibClass)",
                                                   preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}