//
//  BaseViewController.swift
//  iFram
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
import UIKit
public class BaseViewController: UIViewController, NVActivityIndicatorViewable{
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
        addLeftButton()
    }
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    public func setTitForView(title: String)
    {
        self.navigationItem.title = title
    }
    public func  addLeftButton(){
        let menuButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_black_24dp"), style: .Plain, target: self, action: #selector(menu(_:)))
        self.navigationItem.leftBarButtonItem = menuButtonItem
    }
    public func menu(sender: AnyObject){
        slideMenuController()?.toggleLeft()
    }
    
    public func alertView(title : String ,message : String,titleAction : String, completionHandle : (() -> Void)?){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: titleAction, style: .Default, handler: nil)
        
        alertVC.addAction(action)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
        
        completionHandle?()
    }
    
    func activeActivityIndicator() {
        startAnimating(CGSize(width: 50, height: 50), type: .BallSpinFadeLoader, color: UIColor.whiteColor(), padding: 1.0)
    }
    
    func deActiveIndicator() {
        stopAnimating()
    }
}
