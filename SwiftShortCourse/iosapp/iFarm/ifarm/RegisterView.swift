//
//  RegisterView.swift
//  iFarm
//
//  Created by Le Ha Thanh on 9/9/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import OEANotification

class RegisterView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textUser: TextFieldLogin!
    @IBOutlet weak var textPass: TextFieldLogin!
    @IBOutlet weak var btn_Register: ButtonLogin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customRadiusTextField()
        customRadiusButton()
    }
    
    //Funcs Notification Success
    func RegisterSuccess(){
        OEANotification.setDefaultViewController(self)
        OEANotification.notify("Đăng ký thành công !",
                               subTitle: "Mời bạn đăng nhập.... ",
                               image: nil,
                               type: .Success,
                               isDismissable: false,
                               completion: { () -> Void in
                                print("completed")
                                self.dismissViewControllerAnimated(true, completion: nil)
                                
                                
            }, touchHandler: nil)
    }
    
    func RegisterError(){
        OEANotification.setDefaultViewController(self)
        OEANotification.notify("Lỗi đăng ký",
                               subTitle: "Tên đăng ký đã tồn tại",
                               type: NotificationType.Warning,
                               isDismissable: true)
    }
    //Custom Button and TextField
    func customRadiusButton(){
        btn_Register.enabled = false
        btn_Register.setBackgroundAndBorderWidth(UIColor.clearColor(), boderWidth: 2, boderColor: UIColor.lightGrayColor(),titleColor: UIColor.lightGrayColor())
        btn_Register.addTarget(self, action: #selector(action_Register), forControlEvents: .TouchUpInside)
        
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
    
    @IBAction func back_Login(sender: AnyObject) {
    
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func action_Register(){
        if let username = textUser.text, password = textPass.text {
            
            let params = ["email": username,
                          "password": password]
            
            
            router.registerUser(params, success: { (_) in
                self.RegisterSuccess()
                }, failed: { (error) in
                    print(error)
                    self.RegisterError()
            })
        }else{
            //You need fill all username and password
        }
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
            action_Register()
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        textField.addTarget(self, action: #selector(checkCharacterInput), forControlEvents: .EditingChanged)
        return true
    }
    
    func checkCharacterInput(){
        if(textUser.text != "" && textPass.text != ""){
            btn_Register.enabled = true
            btn_Register.setBackgroundAndBorderWidth(UIColor.baseColor(), boderWidth: 0, boderColor: UIColor.greenColor(),titleColor: UIColor.whiteColor())
        }else{
            btn_Register.enabled = false
            btn_Register.setBackgroundAndBorderWidth(UIColor.clearColor(), boderWidth: 2, boderColor: UIColor.lightGrayColor(),titleColor: UIColor.lightGrayColor())
        }
        
    }
    
}
