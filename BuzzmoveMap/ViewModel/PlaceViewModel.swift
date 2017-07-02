//
//  Place.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 01/07/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import MapKit

class PlaceViewModel : NSObject, MKAnnotation {

    let placeId: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let iconUrl: String?
    let photoReference: String?
    let photoHeight: Int16?
    let photoWidth: Int16?
    var title: String? //must implement title when canShowCallout is YES on corresponding view
    
    
    ///
    /// Create Place View Model using feed data
    ///
    init(name: String, placeId: String, location: (lat: Double, long: Double),
         address: String, iconUrl: String?,photoReference: String?, photoHeight: Int16?, photoWidth: Int16?  ) {
        self.name = name
        self.title = name
        self.placeId = placeId
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.lat), longitude: CLLocationDegrees(location.long))
        self.address = address
        self.iconUrl = iconUrl
        self.photoReference = photoReference
        self.photoWidth = photoWidth
        self.photoHeight = photoHeight
    }
    

    ///
    /// Create Place View Model using managed object
    ///
    convenience init(place: Place) {
        // safe to force unwrap properties of Place (managed object) because in datamodel I made these
        // properties as non optional.
        self.init(name: place.name!, placeId: place.placeId!, location: (lat: place.lat, long: place.long),
                  address: place.address!, iconUrl: place.iconUrl,
                  photoReference: place.photoReference, photoHeight: place.photoHeight, photoWidth: place.photoWidth)

    }
    
}


