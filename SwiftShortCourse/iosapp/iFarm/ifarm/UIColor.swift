//
//  UIColor.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/5/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }

    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = NSScanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    class func textColor() -> UIColor {
        return UIColor(red: 91.0 / 255.0, green: 90.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }
    
    class func baseColor() -> UIColor {
        return UIColor(red: 80.0 / 255.0, green: 174.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    }
    
    class func highlightColor() -> UIColor {
        return UIColor(red: 243.0 / 255.0, green: 95.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
    }
    
    class func textInputColor() -> UIColor {
        return UIColor(white: 64.0 / 255.0, alpha: 1.0)
    }
    
    class func menuColorColor() -> UIColor {
        return UIColor(red: 51.0 / 255.0, green: 133.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
}
