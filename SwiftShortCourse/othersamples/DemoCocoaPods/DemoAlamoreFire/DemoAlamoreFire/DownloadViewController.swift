//
//  DownloadViewController.swift
//  DemoAlamoreFire
//
//  Created by Vinh The on 8/31/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {
    
    @IBOutlet weak var downloadTableView: UITableView!
    
    var images = [Image]()
    
    
    var isDownload : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        
        getImageRequest()
        
        print(DOCUMENT_URL)
    }
    
    func getImageRequest() {
        //Get thông tin tất cả Image
        Alamofire.request(.GET, IMAGE_URL + GET_IMAGE_API, headers : header)
            .validate()
            .responseJSON { (repsonse) in
                switch repsonse.result{
                case.Success:
                    let json = JSON(data: repsonse.data!)
                    
                    for (_, dictionary) in json{
                        let image = Image(id: dictionary["id"].intValue,
                            name: dictionary["name"].stringValue,
                            urlImage: dictionary["photofile"].stringValue)
                        
                        self.images.append(image)
                    }
                    self.downloadTableView.reloadData()
                    
                case.Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}

extension DownloadViewController : UITableViewDataSource, UITableViewDelegate, DownloadImageCell{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadCell", forIndexPath: indexPath) as! ImageCell
        
        cell.cellDelegate = self
        
        let image = images[indexPath.row]
        
        cell.configureCell(image)
        
        return cell
    }
    
    //Image Cell Delegate
    func downloadImage(cellIndexPath: ImageCell, progressBar: UIProgressView, processLabel: UILabel, downloadButton : UIButton) {
        
        guard let indexPath = downloadTableView.indexPathForCell(cellIndexPath) else {return}
        
        let image = images[indexPath.row]
        
        requestDownloadImage(image, progressBar: progressBar, processLabel: processLabel, downloadButton: downloadButton)
    }
    
    func requestDownloadImage(image : Image, progressBar : UIProgressView, processLabel : UILabel, downloadButton : UIButton) {
        
        Alamofire.download(.GET, IMAGE_URL + image.urlImage) { (temporaryURL, response) -> NSURL in
            //Tạo URL directory để lưu image download được
            let downloadPath = DOCUMENT_URL.URLByAppendingPathComponent("\(image.name)")
            
            do{
                try NSFileManager.defaultManager().createDirectoryAtURL(downloadPath, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print(error.localizedDescription)
            }
            
            self.saveImageInformation(image, path: downloadPath)
            
            return downloadPath.URLByAppendingPathComponent("\(image.name).png")
            
            }.progress { (byteRead, totalByteRead, totalByteExpectToRead) in
                print(totalByteRead, totalByteExpectToRead)
                //Closure quá trình download
                let percent = (Float(totalByteRead) / Float(totalByteExpectToRead))
                
                dispatch_async(dispatch_get_main_queue(), {
                    downloadButton.hidden = true
                    self.configureStateOfComponents(progressBar, processLabel: processLabel,  processDownload: percent, hiddenComponent: false)
                })
            }.response { (request, response, data, error) in
                
                //Closure sau khi hoàn thành quá trình download
                dispatch_async(dispatch_get_main_queue(), {
                    downloadButton.hidden = false
                    self.configureStateOfComponents(progressBar, processLabel: processLabel, processDownload: 0.0, hiddenComponent: true)
                })
                
        }
    }
    
    
    //Tạo plist để save lại thông tin hình
    func saveImageInformation(image : Image, path : NSURL) {
        let imageInformation = NSMutableDictionary()
        
        imageInformation["name"] = image.name
        imageInformation["imageURL"] = "\(image.name)/ImageDownloaded.png"
        
        let infoPath = path.URLByAppendingPathComponent("imageInfo.plist")
        
        imageInformation.writeToURL(infoPath, atomically: true)
    }
    
    //Chỉnh trạng thái của các component trong cell.
    func configureStateOfComponents(progressBar : UIProgressView, processLabel : UILabel,  processDownload : Float, hiddenComponent : Bool) {
        
        progressBar.hidden = hiddenComponent
        processLabel.hidden = hiddenComponent
        
        progressBar.setProgress(processDownload, animated: true)
        processLabel.text = String(format: "%.f %%", processDownload * 100)
    }
    
}