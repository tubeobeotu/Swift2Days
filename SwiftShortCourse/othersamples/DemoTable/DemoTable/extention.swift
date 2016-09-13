//
//  extention.swift
//  TipTricks_UITableView
//
//  Created by Tuuu on 9/10/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit
extension UIImageView {

    func downloadImageFrom(link link:String, contentMode: UIViewContentMode, completetion: ((UIImage) -> Void)?) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data {
                    self.image = UIImage(data: data)
                    if (completetion != nil)
                    {
                        completetion!(self.image!)
                    }
                }
            }
        }).resume()
    }
}