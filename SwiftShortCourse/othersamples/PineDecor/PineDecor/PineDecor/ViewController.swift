//
//  ViewController.swift
//  PineDecor
//
//  Created by DangCan on 4/13/16.
//  Copyright © 2016 DangCan. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var bgView: Item!
    var imageList = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.onTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    func onTap(tapGesture: UITapGestureRecognizer)
    {
        let point = tapGesture.locationInView(self.view)
        let snowFlake = UIImageView(image: UIImage(named: "snowflake.png"))
        snowFlake.bounds.size = CGSize(width: 40, height: 40)
        snowFlake.center = point;
        self.view.addSubview(snowFlake)
        
    }
}

