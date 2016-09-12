//
//  ManageFarm.swift
//  iFram
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ManageFarms: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    var myCollectionView: UICollectionView!
    var btn_Add : UIButton!
    var farms = [Farm]()
    var page = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        title = "Quản lý nông trại"
        addCollectionView()
        addBtn()
        getFarm(page) { 
            self.myCollectionView.reloadData()
            self.deActiveIndicator()
        }
        
        myCollectionView.es_addInfiniteScrolling { 
            [weak self] in
            
            self!.page += 1
            
            self!.getFarm(self!.page, completionHandle: { 
                self!.myCollectionView.reloadData()
                self!.deActiveIndicator()
                self?.myCollectionView.es_stopLoadingMore()
                self?.myCollectionView.es_noticeNoMoreData()
            })
        }
        
        myCollectionView.es_addPullToRefresh(animator:CustomPullToRefreshView(frame: CGRect.zero)){
            [weak self] in
            
            self?.farms.removeAll()
            
            self?.page = 1
            
            self!.getFarm(self!.page, completionHandle: {
                self!.myCollectionView.reloadData()
                self!.deActiveIndicator()
                self?.myCollectionView.es_stopPullToRefresh(completion: true)
            })
        }

    }
    
    func addCollectionView()
    {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        self.myCollectionView = UICollectionView(frame: CGRectMake(100, 160, 100, 100), collectionViewLayout: layout)
        self.myCollectionView.backgroundColor = UIColor.whiteColor()
        myCollectionView!.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        self.myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(myCollectionView)
        let layoutHeight = NSLayoutConstraint(item: myCollectionView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutY = NSLayoutConstraint(item: myCollectionView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let layoutX = NSLayoutConstraint(item: myCollectionView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let layoutWidth = NSLayoutConstraint(item: myCollectionView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
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
        let createFarm = CreateFarm(nibName: "CreateFarm", bundle: nil)
        self.navigationController?.pushViewController(createFarm, animated: true)
    }
    
    // Get Data
    
    func getFarm(page : Int, completionHandle : (()->Void)) {
        
        activeActivityIndicator()
        
        router.getFarm(page, success: { (data) in
            
            let json = JSON(data: data as! NSData)
            
            for (_, farmInformation) in json{
                let image = Farm(farmInfo: farmInformation)
                
                self.farms.append(image)
            }
            
            completionHandle()
            
        }) { (error) in
            
            self.alertView("Warning", message: error.localizedDescription, titleAction: "OK", completionHandle: nil)
            
            completionHandle()
        }
    }
    
    //DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return farms.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        
        let farm = farms[indexPath.item]
        
        cell.configureCell(farm)
        
        return cell
    }
    
    
    //layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(146, 168)
    }
    
    
    //delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let detailFarm = DetailFarm(nibName: "DetailFarm", bundle: nil)
        
        self.navigationController?.pushViewController(detailFarm, animated: true)
        
        let farm = farms[indexPath.item] 
        
        detailFarm.farm = farm
        
    }
    
    
}
