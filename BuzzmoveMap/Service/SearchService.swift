//
//  SearchService.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 30/06/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation

protocol PlaceSearchService {
    
    typealias SearchResult = ([PlaceViewModel]?, String?) -> ()
    
    func getPlaceSearchResults(searchTerm: String, completion: @escaping SearchResult)

}
