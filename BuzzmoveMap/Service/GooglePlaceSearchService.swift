//
//  PlaceSearchService.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 30/06/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation

/**
 GooglePlaceSearchService is a PlaceSearchService which uses Google place search api to search places and responsible
 to parse json payload response from Google place search api
 */
class GooglePlaceSearchService: PlaceSearchService {
    
    typealias JSONDictionary = [String: Any]
    let defaultSession = URLSession(configuration: .default)
    var sessionDataTask: URLSessionDataTask?
    var placeViewModels: [PlaceViewModel] = []
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
                        completion(self.placeViewModels, self.errorMessage)
                        self.placeViewModels = []
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
        
        for placeDictionary in array {
            if let placeDictionary = placeDictionary as? JSONDictionary,
                let placeID = placeDictionary["place_id"] as? String,
                let name = placeDictionary["name"] as? String,
                let address = placeDictionary["formatted_address"] as? String,
                let geometry = placeDictionary["geometry"] as? JSONDictionary,
                let location = geometry["location"] as? JSONDictionary,
                let lat = location["lat"] as? Double,
                let lng = location["lng"] as? Double,
                let iconUrl = placeDictionary["icon"] as? String,
                let photos = placeDictionary["photos"] as? [Any],
                let photo = photos.first as? [String : Any],
                let photoReference = photo["photo_reference"] as? String,
                let photoWidth = photo["width"] as? Int16,
                let photoHeight = photo["height"] as? Int16 {
                
                self.placeViewModels.append(PlaceViewModel(name: name, placeId: placeID, location: (lat: lat, long: lng), address: address, iconUrl: iconUrl, photoReference: photoReference, photoHeight: photoHeight, photoWidth: photoWidth))
            
            } else {
                self.errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }

}
