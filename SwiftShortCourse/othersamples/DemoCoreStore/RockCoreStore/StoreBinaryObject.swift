//
//  StoreBinaryObject.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/11/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import CoreStore

class StoreBinaryObject: UIViewController {

    @IBOutlet weak var originalPhoto: UIImageView!
    
    @IBOutlet weak var savedPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.None
    }

    @IBAction func onSavePhoto(sender: AnyObject) {
        
        HumanResource.dataStack.beginSynchronous { transaction in
            
            transaction.deleteAll(From(Photo))
            let photo = transaction.create(Into<Photo>())
            photo.name = "Tiger"
            photo.data =  UIImagePNGRepresentation(self.originalPhoto.image!)
            
            transaction.commitAndWait()
            
            
        }
        
        if let savedphoto = HumanResource.dataStack.fetchOne(From(Photo)) {
            savedPhoto.image = UIImage(data: savedphoto.data!, scale: 1.0)
        }

    }
}
