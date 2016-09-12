//
//  CustomPullToRefreshView.swift
//  iFarm
//
//  Created by Vinh The on 9/11/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

public class CustomPullToRefreshView: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    public var insets: UIEdgeInsets = UIEdgeInsetsZero
    public var trigger: CGFloat = 60.0
    public var executeIncremental: CGFloat = 100
    public var view: UIView { return self }
    
    let activity = NVActivityIndicatorView(frame: CGRectMake(0, 0, 0, 0), type: .BallPulse, color: UIColor.baseColor(), padding: nil)
    let imageView: UIImageView = UIImageView(image: UIImage(named: "Logo"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view.addSubview(activity)
        view.addSubview(imageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRectMake(0, 20, view.bounds.size.width / 4.0, view.bounds.size.height / 3.5)
        
        imageView.center.x = view.center.x
        
        activity.frame = CGRectMake(0, imageView.bounds.size.height + imageView.frame.origin.y + 5, 40, 40)
        activity.center.x = view.center.x
    }
}

extension CustomPullToRefreshView {
    
    public func refreshAnimationDidBegin(view: ESRefreshComponent){
        print("did start")
        
        activity.startAnimating()
        
    }
    
    public func refreshAnimationDidEnd(view: ESRefreshComponent){
        print("did end")
        
        activity.stopAnimating()
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat){
    
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState){
    }
}
