//
//  LocationAnnotation.swift
//  iHotel
//
//  Created by DangCan on 2/20/16.
//  Copyright © 2016 DangCan. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image : String?
    init(coordinate: CLLocationCoordinate2D, title: String)
    {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String, image: String)
    {
        self.coordinate = coordinate
        self.title = title
        self.image = image
        super.init()
    }
    
    
}
