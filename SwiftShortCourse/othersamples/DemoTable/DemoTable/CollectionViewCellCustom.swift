//
//  CollectionViewCellCustom.swift
//  TipTricks_UITableView
//
//  Created by Tuuu on 9/10/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

class CollectionViewCellCustom: UICollectionViewCell {

    @IBOutlet weak var imgViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes
        {
            imgViewHeightContraint.constant = attributes.photoHeight
        }
    }
}
