//
//  PostViewController.swift
//  DemoAlamoreFire
//
//  Created by Vinh The on 8/30/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var addressTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createPersonAction(sender: AnyObject) {
        // Kiểm tra nếu cả 4 textfield # nil thì chạy lên POST - create new person
        if let name = nameTextField.text, address = addressTextField.text, phone = phoneTextField.text, email = emailTextField.text {
            createPerson(name, address: address, phone: phone, email: email)
        }else{
            self.statusLabel.text = "You are missing field"
        }

    }
    
    func createPerson(name : String, address : String, phone : String, email : String) {
        
        //Parameter truyền lên endPoint
        let param : [String : String] = ["name":name,
                                         "address":address,
                                         "phone":phone,
                                         "email" : email]
        
        Alamofire.request(.POST, baseURL + createPersonAPI, parameters: param) // Truyền param vào request
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case.Success:
                    self.statusLabel.text = "Success"
                    self.nameTextField.text = ""
                    self.phoneTextField.text = ""
                    self.addressTextField.text = ""
                    self.emailTextField.text = ""
                case.Failure(let error):    
                    self.statusLabel.text = error.localizedDescription
                }
        }
        
    }
    
}
