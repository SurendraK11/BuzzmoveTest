//
//  SearchService.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 30/06/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import UIKit

/**
 PlaceSearchService is responsible to provide places based on given search query
 */
protocol PlaceSearchService {
    
    typealias SearchResult = ([PlaceViewModel]?, String?) -> ()
    

    ///
    /// Allows to search places for given search tearm e.g. searchTerm = "Schools in london"
    ///
    /// - Parameters:
    ///   - searchTerm: search query
    ///   - completion: completion handler
    func getPlaceSearchResults(searchTerm: String, completion: @escaping SearchResult)

}
