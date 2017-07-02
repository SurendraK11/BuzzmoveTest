//
//  CoreDataPersistedDataServiceSpec.swift
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

class CoreDataPersistedDataServiceSpec: QuickSpec {
    let coreDataPersistedDataService = CoreDataPersistedDataService()
    
    private func resetPlaceEntity() {
        coreDataPersistedDataService.deleteAllRecordsFromPlaceEntity()
    }
    
    private func getPlaceViewModel() -> PlaceViewModel {
        return PlaceViewModel(name: "place name", placeId: "place id", location: (lat: 345, long: 34634),
                              address: "place address", iconUrl: "icon url", photoReference: "photo ref", photoHeight: 36,
                              photoWidth: 36)
    }
    
    override func spec() {
        context("testing coredata operations - create, delete all") {
            describe("testing create Place using PlaceViewModel - createPlacesInPlaceEntity", closure: {
                self.resetPlaceEntity()
                let placeViewModel = self.getPlaceViewModel()
                self.coreDataPersistedDataService.createPlacesInPlaceEntity(usingPlaceViewModels: [placeViewModel])
                let places = self.coreDataPersistedDataService.fetchAllRecordsFromPlaceEntity()
                expect(places).notTo(beNil())
                expect(places.count) == 1
            })
            
            describe("testing delete all places deleteAllRecordsFromPlaceEntity", closure: {
                self.resetPlaceEntity()
                let placeViewModel = self.getPlaceViewModel()
                self.coreDataPersistedDataService.createPlacesInPlaceEntity(usingPlaceViewModels: [placeViewModel])
                var places = self.coreDataPersistedDataService.fetchAllRecordsFromPlaceEntity()
                expect(places).notTo(beNil())
                expect(places.count) == 1
                self.coreDataPersistedDataService.deleteAllRecordsFromPlaceEntity()
                places = self.coreDataPersistedDataService.fetchAllRecordsFromPlaceEntity()
                expect(places.count) == 0
            })
        }
    }
}
