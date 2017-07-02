//
//  Place.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 01/07/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import MapKit

/**
 PlaceViewModel this is an important view model object which is used to show data
 */
class PlaceViewModel : NSObject, MKAnnotation {

    let placeId: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let iconUrl: String
    let photoReference: String
    let photoHeight: Int16
    let photoWidth: Int16
    
    //must implement title when canShowCallout is YES on corresponding view
    var title: String?
    
    ///
    /// Create Place View Model using feed data
    ///
    /// - Parameters:
    ///   - name: place name
    ///   - placeId: place id
    ///   - location: geometrical location of the place
    ///   - address: place address
    ///   - iconUrl: place type icon
    ///   - photoReference: place reference which is being used to get place photo
    ///   - photoHeight: place photo height
    ///   - photoWidth: place photo width
    init(name: String, placeId: String, location: (lat: Double, long: Double),
         address: String, iconUrl: String,photoReference: String, photoHeight: Int16, photoWidth: Int16) {
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
    /// This is just a convenience method to create Place View Model using managed object (Place)
    /// Note: Please do not create strong reference of managed object (place) here
    /// - Parameter place: Place managed object
    ///
    convenience init(place: Place) {
        // safe to force unwrap properties of Place (managed object) because in datamodel I made these
        // properties as non optional.
        self.init(name: place.name!, placeId: place.placeId!, location: (lat: place.lat, long: place.long),
                  address: place.address!, iconUrl: place.iconUrl!,
                  photoReference: place.photoReference!, photoHeight: place.photoHeight, photoWidth: place.photoWidth)

    }
    
}


