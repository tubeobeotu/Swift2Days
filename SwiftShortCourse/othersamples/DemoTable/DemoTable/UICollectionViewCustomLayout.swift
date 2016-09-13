//
//  UICollectionViewCustomLayout.swift
//  TipTricks_UITableView
//
//  Created by Tuuu on 9/10/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit
import AVFoundation


class UICollectionViewCustomLayout: UICollectionViewController {
    private let reuseIdentifier = "Cell"
    let photos = ["0", "1", "2", "3", "4", "5", "6"]
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.registerNib(UINib(nibName: "CollectionViewCellCustom", bundle: nil), forCellWithReuseIdentifier: "Cell")
        view.backgroundColor = UIColor.blackColor()
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
    }
    
}

extension UICollectionViewCustomLayout {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCellCustom
        cell.img.image = UIImage(named:photos[indexPath.item])
        cell.img.contentMode = .ScaleToFill
        return cell
    }
    
}

extension UICollectionViewCustomLayout : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        let photo = UIImage(named:photos[indexPath.item])
        return photo!.size.height
    }


    
}
