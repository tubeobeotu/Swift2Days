//
//  ManageSensors.swift
//  iFram
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

class ManageSensors: BaseViewController, RATreeViewDelegate, RATreeViewDataSource{
    
    var treeView : RATreeView!
    var data = [DataObject]()
    var btn_Add : UIButton!
    var dataObj: DataObject!
    var farmAdded = [Farm]()
    var indexFarm = 0
    var page = 1
    
    convenience init() {
        self.init(nibName : nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        activeActivityIndicator()
        
        commonInit { (dataObject,farmArray) in
            
            self.data = dataObject!
            
            self.farmAdded = farmArray!
            
            self.view.backgroundColor = UIColor.whiteColor()
            self.title = "Quản lý cảm biến"
            self.setupTreeView()
            self.addBtn()
            self.btn_Add.enabled = false
            self.treeView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        commonInit {(dataObject, farmArray) in
            
            self.data = dataObject!
            
            self.farmAdded = farmArray!
            
        }    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func setupTreeView() -> Void {
        treeView = RATreeView(frame: view.bounds)
        treeView.registerNib(UINib.init(nibName: "TreeTableViewCell", bundle: nil), forCellReuseIdentifier: "TreeTableViewCell")
        treeView.delegate = self
        treeView.dataSource = self
        
        treeView.backgroundColor = UIColor.clearColor()
        view.addSubview(treeView)
        treeView.translatesAutoresizingMaskIntoConstraints = false
        let layoutHeight = NSLayoutConstraint(item: treeView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutY = NSLayoutConstraint(item: treeView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutX = NSLayoutConstraint(item: treeView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let layoutWidth = NSLayoutConstraint(item: treeView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
    }
    func addBtn()
    {
        self.btn_Add = UIButton(frame: CGRectMake(0, 0, 40, 40))
        self.btn_Add.setImage(UIImage(named: "addNewButton"), forState: .Normal)
        self.btn_Add.addTarget(self, action: #selector(actionAdd), forControlEvents: .TouchUpInside)
        //add Contraint
        self.view.addSubview(self.btn_Add)
        btn_Add.translatesAutoresizingMaskIntoConstraints = false
        let layoutHeight = NSLayoutConstraint(item: btn_Add, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40)
        let layoutY = NSLayoutConstraint(item: btn_Add, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -10)
        let layoutX = NSLayoutConstraint(item: btn_Add, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let layoutWidth = NSLayoutConstraint(item: btn_Add, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
    }
    func actionAdd()
    {
        let createView = CreateSensor(nibName: "CreateSensor", bundle: nil)
        createView.farmSelected = farmAdded[indexFarm]
        self.navigationController?.pushViewController(createView, animated: true)
        
    }
    
    //MARK: RATreeView data source
    
    func treeView(treeView: RATreeView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let item = item as? DataObject {
            return item.children.count
        } else {
            return self.data.count
        }
    }
    
    func treeView(treeView: RATreeView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let item = item as? DataObject {
            return item.children[index]
        } else {
            return data[index] as AnyObject
        }
    }
    
    func treeView(treeView: RATreeView, cellForItem item: AnyObject?) -> UITableViewCell {
        
        let cell = treeView.dequeueReusableCellWithIdentifier("TreeTableViewCell") as! TreeTableViewCell
        
        let item = item as! DataObject
        
        //Lấy ra level
        var detailsText = ""
        let level = treeView.levelForCellForItem(item)
        if level == 0 {
            detailsText = "Tổng số cảm biến \(item.children.count)"
        }
        
        
        cell.setup(withTitle: item.name, detailsText: detailsText, level: level, additionalButtonHidden: true)
        
        
        return cell
    }
    
    //MARK: RATreeView delegate
    func treeView(treeView: RATreeView, heightForRowForItem item: AnyObject) -> CGFloat {
        return 50
    }
    
    func treeView(treeView: RATreeView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowForItem item: AnyObject) {
        guard editingStyle == .Delete else { return; }
        let item = item as! DataObject
        let parent = treeView.parentForItem(item) as? DataObject
        
        
        var index = 0
        if let parent = parent {
            //Duyệt qua tất cả các phần thử children xem phần tử nào là phần tử mình select thì xoá
            // === là trùng địa chỉ
            index = parent.children.indexOf({ dataObject in
                
                return dataObject === item
            })!
            let pathURL = item.name
            
            let escapedAddress = pathURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            activeActivityIndicator()
            Router.shareInstance.deleteSensor(escapedAddress!, success: { (_) in
                self.deActiveIndicator()
                }, failed: { (error) in
                    self.deActiveIndicator()
                    self.alertView("Warning", message: error!.localizedDescription , titleAction: "OK", completionHandle: nil)
            })
            
            parent.removeChild(item)
            
            
        } else {
            index = self.data.indexOf({ dataObject in
                return dataObject === item
            })!
            
            activeActivityIndicator()
            
            Router.shareInstance.deleteFarm(farmAdded[index].id, success: { (_) in
                self.deActiveIndicator()
                self.farmAdded.removeAtIndex(index)
                }, failed: { (error) in
                    self.deActiveIndicator()
                    self.alertView("Warning", message: error!.localizedDescription , titleAction: "OK", completionHandle: nil)
            })
            
            
            self.data.removeAtIndex(index)
            
        }
        
        
        self.treeView.deleteItemsAtIndexes(NSIndexSet.init(index: index), inParent: parent, withAnimation: RATreeViewRowAnimationRight)
        if let parent = parent {
            self.treeView.reloadRowsForItems([parent], withRowAnimation: RATreeViewRowAnimationNone)
        }
        
    }
    
    func treeView(treeView: RATreeView, didSelectRowForItem item: AnyObject) {
        
        let item = item as! DataObject
        
        //Lấy ra level
        let level = treeView.levelForCellForItem(item)
        
        if (level == 0)
        {
            changeIconButton(item)
            btn_Add.enabled = true
            dataObj = item
        }
        
        if let index = (data.indexOf { (dataObj) -> Bool in
            return dataObj === item
            })
        {
            indexFarm = index
        }
        
    }
    
    // hàm đổi icon khi ấn vào row
    func changeIconButton(item : DataObject){
        let cell = treeView.cellForItem(item) as! TreeTableViewCell
        
        if !treeView.isCellExpanded(cell){
            cell.iconButton.setImage(UIImage(named: "subtract"), forState: .Normal)
        } else {
            cell.iconButton.setImage(UIImage(named: "plus"), forState: .Normal)
        }
        
    }
    
    func commonInit(success : ([DataObject]?,[Farm]?) -> Void) {
        var dataObject = [DataObject]()
        
        var farmArrays = [Farm]()
        
        router.getFarm(page ,success: { (data) in
            
            let json = JSON(data: data as! NSData)
            
            self.deActiveIndicator()
            
            for (_, farmInformation) in json{
                let farm = Farm(farmInfo: farmInformation)
                
                farmArrays.append(farm)
            }
            
            var indexSensor:Int = 0
            
            for farm in farmArrays {
                
                var sensorArray = [Sensor]?()
                
                router.getSensorWithFarmID(farm.id, success: { (value) in
                    
                    indexSensor = indexSensor + 1
                    
                    sensorArray = value as? [Sensor]
                    
                    var dataChildren = [DataObject]()
                    
                    for children in sensorArray! {
                        dataChildren.append(DataObject(name: children.id))
                        
                    }
                    
                    dataObject.append(DataObject(name: farm.title!, children: dataChildren))
                    
                    
                    if(indexSensor == farmArrays.count){
                        success(dataObject, farmArrays)
                        
                    }
                    
                    }, failed: { (error) in
                        print(error)
                })
            }
            
        }) { (error) in
            self.deActiveIndicator()
        }
    }
    
    
}
