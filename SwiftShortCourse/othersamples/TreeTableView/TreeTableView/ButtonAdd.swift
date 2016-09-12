//
//  ButtonAdd.swift
//  TreeTableView
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit
class ButtonAdd: UIButton {
    
    /// Color of the background rectangle
    var roundRectColor: UIColor = UIColor.baseColor() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    // MARK: Private
    
    private var roundRectLayer: CAShapeLayer?
    
    private func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width/2).CGPath
        shapeLayer.fillColor = roundRectColor.CGColor
        self.layer.insertSublayer(shapeLayer, atIndex: 0)
        self.roundRectLayer = shapeLayer
    }
}