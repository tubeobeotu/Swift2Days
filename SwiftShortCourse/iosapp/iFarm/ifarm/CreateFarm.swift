//
//  CreateFarm.swift
//  iFram
//
//  Created by Tuuu on 9/1/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

class CreateFarm: BaseViewController, UIScrollViewDelegate {
    var lbl_name: UILabel!
    var lbl_description: UILabel!
    var tv_name: TextViewCornerRadius!
    var tv_description: TextViewCornerRadius!
    var pageController: UIPageControl!
    var scrollView: UIScrollView!
    var btn_add: ButtonLogin!
    var imgFarms = ["farm1", "farm2", "farm3", "farm1", "farm2", "farm3", "farm1"]
    
    var first = false
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContraints()
        title = "Tạo mới nông trại"
        pageController.pageIndicatorTintColor = UIColor.blackColor()
        pageController.currentPageIndicatorTintColor = UIColor.baseColor()
        pageController.currentPage = currentPage
        pageController.numberOfPages = imgFarms.count/3 + ((imgFarms.count%3) > 0 ? 1 : 0)
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        if (!first){
            first = true
            
            // 134 là bằng kích thước ảnh ( = 124) + khoảng cách giữa các ảnh ( = 10)
            scrollView.contentSize = CGSizeMake(CGFloat(134*imgFarms.count), 0)
            scrollView.contentOffset = CGPointMake(CGFloat(currentPage) * 134, 0)
            
            // add image vào scroll view
            for i in 0 ..< imgFarms.count {
                let imgView = UIImageView(image: UIImage(named:imgFarms[i]+".jpg"))
                // custom img
                imgView.layer.cornerRadius = 10
                imgView.layer.borderWidth = 1
                imgView.layer.borderColor = UIColor.whiteColor().CGColor
                imgView.layer.masksToBounds = true
                
                imgView.frame = CGRectMake(CGFloat(134*i), 0, 124, self.scrollView.frame.size.height)
                imgView.contentMode = .ScaleAspectFit
                
                scrollView.addSubview(imgView)
                
                
            }
        }
    }
    //delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width) +
            ((scrollView.contentOffset.x%scrollView.frame.size.width) > 0 ? 1 : 0)
    }
    //addContraint
    func addContraints()
    {
        //lbl_name
        self.lbl_name = UILabel(frame: CGRectMake(100, 160, 100, 100))
        self.lbl_name.text = "Tên"
        self.lbl_name.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.lbl_name)
        var layoutY = NSLayoutConstraint(item: lbl_name, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 8)
        var layoutHeight = NSLayoutConstraint(item: lbl_name, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 20)
        var layoutX = NSLayoutConstraint(item: lbl_name, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 8)
        var layoutWidth = NSLayoutConstraint(item: lbl_name, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //tv_name
        self.tv_name = TextViewCornerRadius(frame: CGRectMake(100, 160, 100, 100))
        self.tv_name.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tv_name)
        layoutY = NSLayoutConstraint(item: tv_name, attribute: .Top, relatedBy: .Equal, toItem: self.lbl_name, attribute: .Bottom, multiplier: 1.0, constant: 8)
        layoutHeight = NSLayoutConstraint(item: tv_name, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35)
        layoutX = NSLayoutConstraint(item: tv_name, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -16)
        layoutWidth = NSLayoutConstraint(item: tv_name, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 16)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //lbl_description
        self.lbl_description = UILabel(frame: CGRectMake(100, 160, 100, 100))
        self.lbl_description.text = "Miêu tả"
        self.lbl_description.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.lbl_description)
        layoutY = NSLayoutConstraint(item: lbl_description, attribute: .Top, relatedBy: .Equal, toItem: self.tv_name, attribute: .Bottom, multiplier: 1.0, constant: 8)
        layoutHeight = NSLayoutConstraint(item: lbl_description, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 20)
        layoutX = NSLayoutConstraint(item: lbl_description, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -8)
        layoutWidth = NSLayoutConstraint(item: lbl_description, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
        //btn_add
        
        self.btn_add = ButtonLogin(frame: CGRectMake(100, 300, 100, 100))
        self.btn_add.addTarget(self, action: #selector(action_Add), forControlEvents: .TouchUpInside)
        self.btn_add.setTitle("Tạo nông trại", forState: .Normal)
        self.btn_add.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.btn_add)
        
        layoutY = NSLayoutConstraint(item: btn_add, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -35)
        layoutHeight = NSLayoutConstraint(item: btn_add, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40)
        layoutX = NSLayoutConstraint(item: btn_add, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -30)
        layoutWidth = NSLayoutConstraint(item: btn_add, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 30)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //pageController
        self.pageController = UIPageControl(frame: CGRectMake(100, 1000, 100, 100))
        self.pageController.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.pageController)
        layoutY = NSLayoutConstraint(item: pageController, attribute: .Bottom, relatedBy: .Equal, toItem: self.btn_add, attribute: .Top, multiplier: 1.0, constant: -35)
        layoutHeight = NSLayoutConstraint(item: pageController, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 37)
        layoutX = NSLayoutConstraint(item: pageController, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -8)
        layoutWidth = NSLayoutConstraint(item: pageController, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //scrollView
        self.scrollView = UIScrollView(frame: CGRectMake(100, 1000, 100, 100))
        self.scrollView.pagingEnabled = true
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        layoutY = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self.pageController, attribute: .Top, multiplier: 1.0, constant: -8)
        layoutHeight = NSLayoutConstraint(item: scrollView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 125)
        layoutX = NSLayoutConstraint(item: scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -16)
        layoutWidth = NSLayoutConstraint(item: scrollView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 16)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //tv_description
        self.tv_description = TextViewCornerRadius(frame: CGRectMake(100, 1000, 100, 100))
        self.tv_description.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tv_description)
        layoutY = NSLayoutConstraint(item: tv_description, attribute: .Top, relatedBy: .Equal, toItem: self.lbl_description, attribute: .Bottom, multiplier: 1.0, constant: 8)
        layoutHeight = NSLayoutConstraint(item: tv_description, attribute: .Bottom, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1.0, constant: -20)
        layoutX = NSLayoutConstraint(item: tv_description, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -16)
        layoutWidth = NSLayoutConstraint(item: tv_description, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 16)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
    }
    
    func action_Add()
    {
        if tv_name.text != "" && tv_description.text != "" {
            
            let params = ["title":tv_name.text,
                          "description":tv_description.text]
            
            activeActivityIndicator()
            
            Alamofire.upload(.POST, "http://192.168.1.99:8000/api/farm/create",headers: header,
                             multipartFormData: { (multiPartFormData) in
                                
                                for (key, value) in params{
                                    multiPartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                                }
                }, encodingCompletion: { (resultEncoding) in
                    switch resultEncoding {
                    case.Success:
                        self.navigationController?.popViewControllerAnimated(true)
                    case.Failure(let error):
                        
                        let error = error as NSError
                        
                        self.alertView("Warning", message: error.localizedDescription, titleAction: "Ok", completionHandle: nil)
                        
                    }
                    
                    self.deActiveIndicator()
            })
        }else{
            self.alertView("Warning", message: "Bạn cần nhập đầy đủ tên và mô tả cho Farm", titleAction: "Ok", completionHandle: nil)
        }
    }
    
    
    
}