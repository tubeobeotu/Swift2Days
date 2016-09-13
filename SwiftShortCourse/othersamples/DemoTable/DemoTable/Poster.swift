//
//  Poster.swift
//  DemoTable
//
//  Created by cuong minh on 11/7/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import Foundation
import UIKit
class Poster {
    var title: String
    var score: Float
    private var _image: UIImage
    var image: UIImage {
        get {
            return _image
        }
    }
    
    init (title: String, imagePath: String, score: Float) {
        self.title = title
        _image = UIImage(named: imagePath)!
        self.score = score
    }
}