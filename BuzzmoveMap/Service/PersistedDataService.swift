//
//  PersistedDataService.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 02/07/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
/**
 PersistedDataService is responsible to provide apis to interact with persistent data stores e.g. coredata
 */
protocol PersistedDataService {


    ///
    /// fetch all places from place entity
    /// - Returns: an array of place
    func fetchAllRecordsFromPlaceEntity() -> [Place]
    
    ///
    /// delete all places from place entity
    ///
    func deleteAllRecordsFromPlaceEntity()
    

    ///
    /// create places in place entity
    /// - Parameter viewModels: an array of PlaceViewModel
    func createPlacesInPlaceEntity(usingPlaceViewModels viewModels: [PlaceViewModel])
}
