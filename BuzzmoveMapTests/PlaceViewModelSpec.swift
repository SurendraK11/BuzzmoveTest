//
//  PlaceViewModelSpec.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 02/07/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData

@testable import BuzzmoveMap

class PlaceViewModelSpec: QuickSpec {
    override func spec() {
        context("testing creation of view model 'PlaceViewModel'") {
           it("should create valid view model using init", closure: {
                let placeViewModel = PlaceViewModel(name: "place name", placeId: "placeID", location: (lat: 51.000898, long: -62.9999879), address: "place address", iconUrl: "iconUrl", photoReference: "lsdcsczzefasdasr", photoHeight: 65, photoWidth: 60)
                expect(placeViewModel).notTo(beNil())
                expect(placeViewModel.address) == "place address"
                expect(placeViewModel.name) == "place name"
                expect(placeViewModel.title).notTo(beNil())
                expect(placeViewModel.title) == placeViewModel.name
            })
            it("should create valid view model using convenience init", closure: {
                let place  = TestSupport().createNewPlace()
                let placeViewModel = PlaceViewModel(place: place)
                expect(placeViewModel).notTo(beNil())
                expect(placeViewModel.address) == "place address"
                expect(placeViewModel.name) == "place name"
                expect(placeViewModel.title).notTo(beNil())
                expect(placeViewModel.title) == placeViewModel.name
            })
        }
    }
}

class TestSupport {
    func createNewPlace() -> Place {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Place", in: context)!
        let place = NSManagedObject(entity: entity, insertInto: context) as! Place
        place.name = "place name"
        place.address = "place address"
        place.placeId = "place id"
        place.lat = 40.00003343
        place.long = -23.000887
        place.iconUrl = "icon url"
        place.photoReference = "photo reference"
        place.photoHeight = 50
        place.photoWidth = 50
        return place
    }
}
