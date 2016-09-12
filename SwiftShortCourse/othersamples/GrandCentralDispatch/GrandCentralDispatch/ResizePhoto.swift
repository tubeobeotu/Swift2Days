//
//  ResizePhoto.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/6/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class ResizePhoto: UIViewController {
    
    weak var dowloadProgress: UIProgressView!
    weak var imageView: UIImageView!
    lazy var downloadsSession: NSURLSession = {
        
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("bgSessionConfiguration")
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    var downloadTask: NSURLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.dowloadProgress.progress = 0.0
        
    }
    
    @IBAction func downloadResize(sender: AnyObject) {
        //let url = NSURL(string: "https://hd.unsplash.com/photo-1465232377925-cce9a9d87843")
        let url = NSURL(string: "https://images.unsplash.com/photo-1470897655254-05feb2d2ab97?dpr=1&auto=compress,format&crop=entropy&fit=crop&w=1199&h=799&q=80&cs=tinysrgb")
        
        if downloadTask != nil {
            downloadTask!.cancel()
        }
        self.imageView.image = nil
        downloadTask = downloadsSession.downloadTaskWithURL(url!)
        self.dowloadProgress.progress = 0.0
        downloadTask!.resume()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        downloadsSession.finishTasksAndInvalidate()
        
    }

}


//MARK: NSURLSessionDownloadDelegate
extension ResizePhoto: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = NSFileManager()
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingString("/image.png"))
        
        if fileManager.fileExistsAtPath(destinationURLForFile.path!){
            showImage(destinationURLForFile)
        }
        else{
            do {
                try fileManager.moveItemAtURL(location, toURL: destinationURLForFile)
                showImage(destinationURLForFile)
            }catch{
                print("Không thể copy file")
            }
        }
    }
    
    
    func showImage(location : NSURL) {
        dispatch_async(dispatch_get_main_queue(), {
            if let data: NSData = NSData(contentsOfURL: location) {
                self.imageView.image = UIImage(data: data)
            }
        })
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        print(totalBytesWritten, totalBytesExpectedToWrite)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.dowloadProgress.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            print("\(self.dowloadProgress.progress)\n")
        })
        
    }
}