//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by ernesto on 01/06/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
protocol PinterestLayoutDelegate {
  // 1. func dùng để lấy ra chiều cao ứng với từng ảnh.
  func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath) -> CGFloat
  
}

class PinterestLayoutAttributes:UICollectionViewLayoutAttributes {
  
  // 1. Custom attribute để co thêm thuộc tính photoHeight để thay đổi giá trị chiều cao của cell theo 
    // chiều cao của anh
  var photoHeight: CGFloat = 0.0
  
  // 2. Override copyWithZone to conform to NSCopying protocol
    //copy nội dùng vào cell, nếu bỏ thì cell sẽ không có nội dung.
  override func copyWithZone(zone: NSZone) -> AnyObject {
    let copy = super.copyWithZone(zone) as! PinterestLayoutAttributes
    copy.photoHeight = photoHeight
    return copy
  }
}


class PinterestLayout: UICollectionViewLayout {
  //1. Pinterest Layout Delegate
  var delegate:PinterestLayoutDelegate!
  
  //2. Số cột trong collectionview
  var numberOfColumns = 2
    //khoảng cách giữa các cell
  var cellPadding: CGFloat = 6.0
  
  //3. Mảng lưu lại các thuộc tính layout của collectionview
  private var cache = [UICollectionViewLayoutAttributes]()
  
  //4. 2 thuộc tính lưu lại chiều cao và chiều rộng nên để private để tranh truy cập trực tiếp .
  private var contentHeight:CGFloat  = 0.0
  private var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
  }
  
  override func prepareLayout() {
    // 1. Check nếu cache chưa có thì mới tính toán ở trong
    if cache.isEmpty {
      
      // 2. Chiều rộng thì bằng chiều dài chia cho số cột trong collectionview
      let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
      var xOffset = [CGFloat]()
      for column in 0 ..< numberOfColumns {
        xOffset.append(CGFloat(column) * columnWidth)
      }
      var column = 0
        
        //Chú ý biến yOffset được set cho toạ độ theo trục Y của mỗi cell.
      var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
      
      // 3. Ở demo này chúng ta chỉ có 1 section nên chúng ta có thể duyệt tất cả các phần tử như sau.
      for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
        
        let indexPath = NSIndexPath(forItem: item, inSection: 0)
        
        // 4. gọi delegate để nó trả về chiều cao của item đó.
        let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath)
        
        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: photoHeight)
        //inset lại frame cho các ảnh cách nhau 1 khoảng
        let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        
        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
        let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.photoHeight = photoHeight
        attributes.frame = insetFrame
        cache.append(attributes)
        
        // 6. Cập nhật chiều cao để khi func collectionViewContentSize gọi trả về được chiều cao hiện tại.
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
        yOffset[column] = yOffset[column] + photoHeight
        
        //Đoạn mã dưới để cho chỉ cột của cell không bị vượt quá tổng số cột cho phép => toạ độ sẽ không bị sai
        if (column >= (numberOfColumns - 1))
        {
          column = 0
        }
        else
        {
          column = column + 1
        }
      }
    }
  }
  
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // Dùng vòng lặp để add attributes cho mỗi thành phần trong cell.
    for attributes in cache {
      if CGRectIntersectsRect(attributes.frame, rect ) {
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }

}


