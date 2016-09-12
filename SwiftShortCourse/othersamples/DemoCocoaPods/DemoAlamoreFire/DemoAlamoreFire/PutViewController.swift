//
//  PutViewController.swift
//  DemoAlamoreFire
//
//  Created by Vinh The on 8/30/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class PutViewController: UIViewController {

    var person : Person?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var addressTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        currentTextFieldValue(person!)
    }
    
    func currentTextFieldValue(person: Person) {
        nameTextField.text = person.name
        phoneTextField.text = person.phone
        addressTextField.text = person.address
        emailTextField.text = person.email
    }
    
    func updateRequest(id : String, name : String, phone : String, email : String, address : String) {
        
        //Parameter truyền lên endPoint
        let param : [String : String] = ["name":name,
                                         "address":address,
                                         "phone":phone,
                                         "email" : email]
        
        Alamofire.request(.PUT, baseURL + "/person/\(id)", parameters: param).validate().responseJSON { (response) in
            switch response.result{
            case.Success:
                self.statusLabel.text = "Success"
            case.Failure(let error):
                print(error.localizedDescription)
            }
        }
    }


    @IBAction func updatePersonAction(sender: AnyObject) {
        
        if let name = nameTextField.text, address = addressTextField.text, phone = phoneTextField.text, email = emailTextField.text {
            updateRequest((person?.id)!, name: name, phone: phone, email: email, address: address)
        }else{
            self.statusLabel.text = "You are missing field"
        }

    }

    
}
