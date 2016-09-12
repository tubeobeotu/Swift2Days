//
//  ImageCell.swift
//  DemoAlamoreFire
//
//  Created by Vinh The on 8/31/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

protocol DownloadImageCell : class {
    func downloadImage(cellIndexPath : ImageCell,
                       progressBar : UIProgressView,
                       processLabel : UILabel,
                       downloadButton : UIButton)
}

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var imageNameLabel: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var processLabel: UILabel!
    
    @IBOutlet weak var processBar: UIProgressView!
    
    @IBOutlet weak var downloadButton: UIButton!
    weak var cellDelegate : DownloadImageCell?
    
    let cacheImage = AutoPurgingImageCache(memoryCapacity: 50 * 1024 * 1024, preferredMemoryUsageAfterPurge: 20 * 1024 * 1024)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        processLabel.hidden = true
        processBar.hidden = true
    }
    
    @IBAction func downloadImage(sender: AnyObject) {
        self.cellDelegate?.downloadImage(self,progressBar: processBar, processLabel: processLabel, downloadButton: downloadButton)
    }
    
    func configureCell(image : Image) {
        imageNameLabel.text = image.name
        
        let imageURL = IMAGE_URL + image.urlImage
        
        // Kiểm tra image đã đc cache hay chưa. Nếu đã cache thì lấy image đã cache đưa vào imageView nếu chưa thì chạy hàm download image
        if let didCachedImage = didImageCached(imageURL){
            myImageView.image = didCachedImage
            return
        }else{
            requestImage(imageURL)
        }
        
    }
    
    // Request and caching Image
    func requestImage(imageURL : String) {
        Alamofire.request(.GET, imageURL).responseImage (inflateResponseImage : true){ (response) in
            if let image = response.result.value
            {
                image.af_inflate()
                self.myImageView.image = image
                self.cachingImage(image, identifier: imageURL)//Cache image func
            }
        }
    }
    
    func cachingImage(image : UIImage, identifier : String) {
        cacheImage.addImage(image, withIdentifier: identifier)
    }
    
    func didImageCached(identifier : String) -> UIImage? {
        return cacheImage.imageWithIdentifier(identifier)
    }
}
