//
//  GetViewController.swift
//  DemoAlamoreFire
//
//  Created by Vinh The on 8/30/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class GetViewController: UIViewController {
    
    @IBOutlet weak var getPersonTableView: UITableView!
    
    var indicator : UIActivityIndicatorView?
    var persons = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getPersonTableView.dataSource = self
        getPersonTableView.delegate = self
        
        indicator = indicatorView(getPersonTableView.tableHeaderView!)
        
    }
    
    //Tất cả các func hoặc instance trong Swift khi được gọi trong Closure thì cần thêm "self."
    
    func requestGetAllPersonsContactList(completionHandle:(()->Void)){
        
        indicator!.startAnimating()
        
        
        Alamofire.request(.GET, NSURL(string: baseURL + getAllAPI)!)
            .validate() //Validate Request theo status code. Trường hợp success Status Code nằm trong range 200..<300.(AUTO - Có thể manual theo yêu cầu)
            .responseJSON { (response) in
                switch response.result{
                case.Success:
                    let json = JSON(data: response.data!) // Khởi tạo đối tượng Swifty JSON bằng data nhận được từ server.
                    
                    // Trường hợp dữ liệu trả về là 1 mảng chứa các dictionary thì tạo 1 vòng lặp để get ra các dictionary chứa trong mảng đấy.
                    
                    for(_, dictionary) in json{
                        let person = Person(id: dictionary["_id"].stringValue, //Sử dụng subscript để lấy ra VALUE theo KEY (đảm bảo giá trị nhận được là 1 giá trị String)
                            name: dictionary["name"].stringValue,
                            phone: dictionary["phone"].stringValue,
                            address: dictionary["address"].stringValue,
                            email: dictionary["email"].stringValue)
                        
                        self.persons.append(person)
                    }
                    
                    completionHandle()
                    
                case.Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    //DELETE Request theo person's ID
    func requestDeletePersonAtIndex(index : NSIndexPath){
        
        let idPerson = persons[index.row].id // Get ID của person theo indexPath
        
        Alamofire.request(.DELETE, baseURL + "/person/\(idPerson)")
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case.Success:
                    self.persons.removeAtIndex(index.row) //Xóa đối tượng trong mảng.
                    self.getPersonTableView.deleteRowsAtIndexPaths([index], withRowAnimation: .Automatic) //Xóa row theo indexPath
                case.Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    @IBAction func getDataAction(sender: AnyObject) {
        
        persons.removeAll()
        
        requestGetAllPersonsContactList {
            //Reload lại TableView sau khi mảng có dữ liệu & stop indicator
            self.getPersonTableView.reloadData()
            self.indicator!.stopAnimating()
        }
        
    }
    
    func indicatorView(parentView : UIView) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        indicatorView.center.x = parentView.center.x
        indicatorView.center.y = parentView.center.y + 20
        indicatorView.activityIndicatorViewStyle = .Gray
        
        parentView.addSubview(indicatorView)
        return indicatorView
    }
    
}

extension GetViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GetCell", forIndexPath: indexPath) as! PersonCell
        let person = persons[indexPath.row]
        
        cell.configureCell(person)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            requestDeletePersonAtIndex(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let putVC = storyboard?.instantiateViewControllerWithIdentifier("PutVC") as! PutViewController
        putVC.person = persons[indexPath.row]
        
        navigationController?.pushViewController(putVC, animated: true)
        
    }
}
