//
//  ViewController.swift
//  MustacheDemoiOS
//
//  Created by Gwendal Roué on 10/03/2015.
//  Copyright (c) 2015 Gwendal Roué. All rights reserved.
//

import UIKit
import GRMustache
import WebKit
class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    var check = false
    override func viewDidLoad() {
        super.viewDidLoad()
        generatePDFReport(getDataFrom("tableContent") as! NSDictionary,
                          paramCollection: [kPageOrientation: 0, kNumberImagesPerPage: 2, kNumberingFormatSingleDigit: true],
                          selectedImages: ["/Users/tuuu/Desktop/Danish/1-1.png", "/Users/tuuu/Desktop/Danish/1-2.png", "/Users/tuuu/Desktop/Danish/2-1.png"])
        
    }
    func generatePDFReport(_ componentCollection : NSDictionary,
                           paramCollection: NSDictionary,
                           selectedImages: NSArray)
    {
        
        let template = try! GRMustacheTemplate(fromResource: "Document", bundle: nil)
//        let template = try! Template(named: paramCollection[kPageOrientation] as! Int == 0 ? "Document" : "DocumentLanspace")
        //Calculate numberOfPage
        let numberOfImagesPerPage:Int = paramCollection[kNumberImagesPerPage] as! Int
        let numberOfPage = selectedImages.count % numberOfImagesPerPage == 0 ? (selectedImages.count / numberOfImagesPerPage) : ((selectedImages.count / numberOfImagesPerPage) + 1)
        
        let data = NSMutableDictionary(dictionary: componentCollection)
        data[kImageWidth] = String(describing: kPaperSizeA4.width/CGFloat(numberOfImagesPerPage))
        data[kImageHeight] = String(describing: kPaperSizeA4.height/CGFloat(numberOfImagesPerPage))
        data.addEntries(from: convertArraySelectedImagesTo(selectedImages, numberOfPages: numberOfPage, numberOfImagesPerPage: numberOfImagesPerPage) as! [AnyHashable: Any])
        

        let rendering = try! template.renderObject(data)
        webView = WKWebView(frame: self.view.frame)
        webView.scrollView.contentSize = CGSize(width: kPaperSizeA4.width, height: CGFloat(numberOfPage) * kPaperSizeA4.height)
        webView.navigationDelegate = self
        webView.loadHTMLString(rendering, baseURL:Bundle.main.bundleURL)
        self.view.addSubview(webView)
        
        
    }
    func convertArraySelectedImagesTo(_ imgs: NSArray, numberOfPages: Int, numberOfImagesPerPage: Int) -> NSDictionary
    {
        var array = [Dictionary<String, String>]()
        for imgName in imgs {
            array.append(["imageName" : imgName as! String])
        }
        return [
            "images": array
        ]
    }
    func getDataFrom(_ table: String) -> Any
    {
        var data = NSMutableDictionary()
        let dataHTML = DataHTML()
        data = NSMutableDictionary(dictionary: dataHTML.getDataFrom(Bundle.main.path(forResource: "demoHTML", ofType: "html")!, table: table))
        data[kWidth] = String(describing: kPaperSizeA4.width)
        data[KHeight] = String(describing: kPaperSizeA4.height)
        return data
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("123")
    }
}
