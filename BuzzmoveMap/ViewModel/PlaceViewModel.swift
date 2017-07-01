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
    let coordinate : CLLocationCoordinate2D
    var title: String? //must implement title when canShowCallout is YES on corresponding view
    
    ///
    /// Create Place View Model using feed data
    ///
    init(name: String, placeId: String, location: (lat: Double, lag: Double), address: String) {
        self.name = name
        self.title = name
        self.placeId = placeId
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.lat), longitude: CLLocationDegrees(location.lag))
        self.address = address
    }
    

    ///
    /// Create Place View Model using managed object
    ///
    init(place: Place) {
        // safe to force unwrap properties of Place (managed object) because in datamodel I made these
        // properties as non optional.
        self.name = place.name!
        self.address = place.address!
        self.placeId = place.placeId!
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.lat), longitude: CLLocationDegrees(place.log))
        self.title = place.name!
    }
    
}


