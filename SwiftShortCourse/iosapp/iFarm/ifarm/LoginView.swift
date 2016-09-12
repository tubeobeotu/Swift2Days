//
//  LoginView.swift
//  iFram
//
//  Created by Tuuu on 9/1/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit
import OEANotification
class LoginView: UIViewController,UITextFieldDelegate{
    
    
    @IBOutlet weak var textUser: TextFieldLogin!
    @IBOutlet weak var textPass: TextFieldLogin!
    @IBOutlet weak var btn_Login: ButtonLogin!
    @IBOutlet weak var btn_Register: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        customRadiusTextField()
        customRadiusButton()
    }
    
    
    //Funcs Notification Login
    func LoginSuccess(){
        OEANotification.setDefaultViewController(self)
        OEANotification.notify("Đăng nhập thành công !",
                               subTitle: "Chào mừng bạn đến với .... ",
                               image: nil,
                               type: .Success,
                               isDismissable: false,
                               completion: { () -> Void in
                                print("completed")
                                self.addMenu()
            }, touchHandler: nil)
    }
    func LoginError(){
        OEANotification.setDefaultViewController(self)
        OEANotification.notify("Lỗi đăng nhập",
                               subTitle: "Vui lòng kiểm tra lại tên đăng nhập và mật khẩu",
                               type: NotificationType.Warning,
                               isDismissable: true)
    }
    func addMenu()
    {
        // Override point for customization after application launch.
        let managerFarm = ManageFarms(nibName: "ManageFarms",
                                      bundle: nil)
        let menuView = MenuView(nibName: "MonitorFarm",
                                bundle: nil)
        let nvc: UINavigationController = BaseNavigationController(rootViewController: managerFarm)
        menuView.manageFarms = nvc
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: menuView)
        self.presentViewController(slideMenuController,
                                   animated: true,
                                   completion: nil)
    }
    //Custom Button and TextField
    func customRadiusButton(){
        btn_Login.enabled = false
        btn_Login.setBackgroundAndBorderWidth(UIColor.clearColor(), boderWidth: 2, boderColor: UIColor.lightGrayColor(),titleColor: UIColor.lightGrayColor())
        btn_Login.addTarget(self, action: #selector(action_Login), forControlEvents: .TouchUpInside)
        
    }
    func customRadiusTextField(){
        textUser.addIconTextField(textUser,
                                  stringImage: "Username Icons")
        textUser.delegate = self
        
        textPass.addIconTextField(textPass,
                                  stringImage: "Password Icons")
        textPass.delegate = self
        
        dispatch_async(dispatch_get_main_queue()) {
            self.textUser.roundTopCornersRadius(6)
            self.textPass.roundBottomCornersRadius(6)
        }
        
    }
    //action when touch in button login
    func action_Login(){
        
        if let username = textUser.text, password = textPass.text {
            
            let params = ["username": username,
                          "password": password]
            
            Router.shareInstance.login(params,
                                       success: { (value) in

                
                let json = JSON(data: value as! NSData)
                
                let session = Session(sessionInfo: json)
                keychain["accessToken"] = session.accessTokenFinal()
                keychain["refreshToken"] = session.refreshToken
                
                header["authorization"] = keychain["accessToken"]
                refreshTokenCode = keychain["refreshToken"]!
                
                self.LoginSuccess()

                }, failled: { (error) in
                    self.LoginError()
            })
            
        }else{
            //You need fill all username and password
        }
        
    }
    
    @IBAction func action_Register(sender: AnyObject) {
        let registerView = RegisterView(nibName: "RegisterView", bundle: nil)
        self.presentViewController(registerView, animated: true, completion: nil)
    }
    
    //hide the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Text Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textUser == textField){
            textPass.becomeFirstResponder()
        }
        
        if(textField == textPass){
            textPass.resignFirstResponder()
            action_Login()
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        textField.addTarget(self, action: #selector(checkCharacterInput), forControlEvents: .EditingChanged)
        return true
    }
    
    func checkCharacterInput(){
        if(textUser.text != "" && textPass.text != ""){
            btn_Login.enabled = true
            btn_Login.setBackgroundAndBorderWidth(UIColor.baseColor(), boderWidth: 0, boderColor: UIColor.greenColor(),titleColor: UIColor.whiteColor())
        }else{
            btn_Login.enabled = false
            btn_Login.setBackgroundAndBorderWidth(UIColor.clearColor(), boderWidth: 2, boderColor: UIColor.lightGrayColor(),titleColor: UIColor.lightGrayColor())
        }
        
    }
    
}
