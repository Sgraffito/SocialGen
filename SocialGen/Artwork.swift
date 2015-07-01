//
//  Artwork.swift
//  SocialGen
//
//  Created by Nicole Yarroch on 7/1/15.
//  Copyright (c) 2015 Nicole Yarroch. All rights reserved.
//

import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String
    let subtitle: String
    let image: String
    let locationName: String // Base64
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, image: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
}