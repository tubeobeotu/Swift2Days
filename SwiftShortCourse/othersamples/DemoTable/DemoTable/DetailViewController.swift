//
//  DetailViewController.swift
//  DemoTable
//
//  Created by cuong minh on 11/18/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {
    var animal: String!
    var webView: UIWebView!
    
    override func loadView() {
        super.loadView()
        webView = UIWebView(frame: view.bounds)
        webView.delegate = self
        view.addSubview(webView)
    }
    override func viewWillAppear(animated: Bool) {
        self.title = animal
        //URL encode chuỗi cần tìm kiếm
        let encodedQuery = animal.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        //Tạo ra NSURLRequest để chuẩn bị gửi lên server
        let request = NSURLRequest(URL: NSURL(string: "https://www.google.com/search?q=\(encodedQuery!)")!)

        //Gửi yêu cầu (NSURLRequest) lên server
        webView.loadRequest(request)
    }
    
    //MARK: UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("\(request.URL!.host!)  -- \(request.URL!.query!)")
        return true
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        print("Load complete")
    }
    
}
