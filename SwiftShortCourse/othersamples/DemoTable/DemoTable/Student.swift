//
//  Student.swift
//  DemoTable
//
//  Created by cuong minh on 11/18/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import Foundation
class Student {
    var fullName: String
    var score: Double
    var liked: Bool
    init (name: String, score: Double = 0.0, liked: Bool = false) {
        fullName = name
        self.score = score
        self.liked = liked
    }
}