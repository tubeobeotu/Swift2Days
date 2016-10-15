//
//  DataHTML.swift
//  DemoGeneratePDF
//
//  Created by Tuuu on 10/12/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import UIKit

class DataHTML: NSObject {
    let kImg = "img"
    let kSrc = "src"
    func getDataFrom(_ path: String, table: String) -> Dictionary<String, String>
    {
        var dic = Dictionary<String, String>()
        if let elements = getElementsFrom(path, table: table, node: "/tr/td")
        {
            for node in elements
            {
                var value = ""
                for child in node.children
                {
                    var attributes = (child as! TFHppleElement).attributes
                    //get values
                    if ((child as! TFHppleElement).tagName == kImg)
                    {
                        
                        value = value + (child as! TFHppleElement).object(forKey: kSrc)
                        attributes?.removeValue(forKey: kSrc)
                    }
                    else
                    {
                        if let content = (child as! TFHppleElement).content
                        {
                            value = value + content
                        }
                    }
                }
                if let key = node.object(forKey:"id") , value != ""
                {
                    dic[key] = value
                }
            }
        }
        return dic
    }
//    func getAttributesFrom(_ path: String, table: String)
//    {
//        var dic = Dictionary<String, String>()
//        if let elements = getElementsFrom(path, table: table, node: "")
//        {
//            print(elements.first?.attributes)
//            print(getAttributesFrom(elements.first!))
//        }
//    }
//    fileprivate func getAttributesFrom(_ node: TFHppleElement) -> String
//    {
//        var nodeAttributes = ""
//        for element in node.children {
//            print(node.content)
//            let attributes = (element as! TFHppleElement).attributes
//            for attribute in attributes
//            {
//                nodeAttributes = nodeAttributes + "**" + ((attribute.0) as! String) + "=" + "\(attribute.1)"
//            }
//            for childElement in element.children {
//                print((childElement as? TFHppleElement)!.content)
//                print(element.tagName)
//                nodeAttributes = nodeAttributes + "**" + getAttributesFrom(childElement as! TFHppleElement)
//                print("")
//            }
//        }
//        return nodeAttributes
//    }
    
    //Lấy dữ liệu từ docment file từ table với id, table, node
    fileprivate func getElementsFrom(_ path: String, table: String, node: String) -> [TFHppleElement]?
    {
        let parser = TFHpple(htmlData: NSData(contentsOfFile: path) as! Data)
        let string = "//table[@id = '\(table)']\(node)"
        let arr = parser?.search(withXPathQuery: string) as? [TFHppleElement]
        return arr
    }
}
