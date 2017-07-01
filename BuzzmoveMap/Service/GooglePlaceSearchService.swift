//
//  PlaceSearchService.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 30/06/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation

class GooglePlaceSearchService: PlaceSearchService {
    
    typealias JSONDictionary = [String: Any]
    let defaultSession = URLSession(configuration: .default)
    var sessionDataTask: URLSessionDataTask?
    let apiKey = "AIzaSyClTrd2wCY0La4Zwmy_nS7KOsFsdkfeacc"
    var places: [PlaceViewModel] = []
    var errorMessage = ""
    
    func getPlaceSearchResults(searchTerm: String, completion: @escaping PlaceSearchService.SearchResult) {
        
        sessionDataTask?.cancel()
        
        if var urlComponets = URLComponents(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?") {
            urlComponets.query = "query=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&key=\(apiKey)"
            guard let url = urlComponets.url else {
                return
            }
            sessionDataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
                
                defer {
                    self.sessionDataTask = nil
                }
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    //parse feed data on background thread
                    self.updateSearchResults(withData: data)
                    DispatchQueue.main.async {
                        completion(self.places, self.errorMessage)
                        self.places = []
                    }
                }
            })
            self.sessionDataTask?.resume()
        }
    }
    
    private func updateSearchResults(withData data: Data) {
        var response: JSONDictionary?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            self.errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
            self.errorMessage += "Dictionary does not contain results key\n"
            return
        }
        
        var index = 0
        for placeDictionary in array {
            if let placeDictionary = placeDictionary as? JSONDictionary,
                let placeID = placeDictionary["place_id"] as? String,
                let name = placeDictionary["name"] as? String,
                let address = placeDictionary["formatted_address"] as? String,
                let geometry = placeDictionary["geometry"] as? JSONDictionary,
                let location = geometry["location"] as? JSONDictionary,
                let lat = location["lat"] as? Double,
                let lng = location["lng"] as? Double {
                places.append(PlaceViewModel(name: name, placeId: placeID, location: (lat: lat, lag: lng), address: address))
                index += 1
            
            } else {
                self.errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }

}
