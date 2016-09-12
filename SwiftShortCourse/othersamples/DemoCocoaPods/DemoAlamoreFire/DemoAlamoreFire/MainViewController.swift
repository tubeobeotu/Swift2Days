//
//  ViewController.swift
//  DemoAlamoreFire
//
//  Created by Techmaster on 8/28/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

//Note: Alamofire is not guaranteed to call the progress callback on the main queue; therefore you must guard against updating the UI by dispatching to the main queue. Some of Alamofire’s callbacks, such as responseJSON, are called on the main queue by default

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var requestTable: UITableView!
    
    let requestArray = ["GET - DELETE - PUT","POST","DOWNLOAD","UPLOAD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTable.dataSource = self
        requestTable.delegate = self
        
        settingViewControllers()
        title = "Demo Alamofire - Techmaster"
    }
    
    func settingViewControllers() {
        
        
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = requestArray[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let getVC = storyboard?.instantiateViewControllerWithIdentifier("GetVC") as! GetViewController
        let postVC = storyboard?.instantiateViewControllerWithIdentifier("PostVC") as! PostViewController
        let downloadVC = storyboard?.instantiateViewControllerWithIdentifier("DownloadVC") as! DownloadViewController
        let uploadVC = storyboard?.instantiateViewControllerWithIdentifier("UploadVC") as! UploadViewController

        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(getVC , animated: true)
        case 1:
            navigationController?.pushViewController(postVC , animated: true)
        case 2:
            navigationController?.pushViewController(downloadVC , animated: true)
        case 3:
            navigationController?.pushViewController(uploadVC , animated: true)
        default:
            print("no VC")
        }
        
        
    }
    
    
}

