//
//  MainChat.swift
//  Chat
//
//  Created by Tuuu on 8/27/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import UIKit
import SocketIOClientSwift
class MainChat: UIViewController {
    var lbl_Name = UILabel(frame: CGRectMake(0, 100, 100, 100))
    var lbl_Temperature = UILabel(frame: CGRectMake(0, 200, 100,100))
    var lbl_Content_Name = UILabel(frame: CGRectMake(20, 100, 100, 100))
    var lbl_Content_Temperature = UILabel(frame: CGRectMake(20, 200, 100, 100))
    var socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.1.130:8000")!, options: [.Log(false), .ForcePolling(true)])
    override func viewDidLoad() {
        super.viewDidLoad()
        addLabel()
        connectToServer()
    }
    func addLabel()
    {
        lbl_Content_Name.textColor = UIColor.blackColor()
        lbl_Content_Temperature.textColor = UIColor.blackColor()
        self.view.addSubview(lbl_Name)
        self.view.addSubview(lbl_Temperature)
        self.view.addSubview(lbl_Content_Name)
        self.view.addSubview(lbl_Content_Temperature)
    }
    func connectToServer()
    {
        socket.connect()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        socket.on("updatingSensort") { (dataArray, socketAck) in
            dispatch_async(dispatch_get_main_queue(), {
                let data = dataArray[0] as! NSDictionary
                let name = data["name"] as! String
                let tmp = String(data["temp"]!)
                self.lbl_Content_Name.text = name
                self.lbl_Content_Temperature.text = tmp
            })
        }
    }


    

}
