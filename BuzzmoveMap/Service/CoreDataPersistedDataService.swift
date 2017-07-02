//
//  CoreDataPersistedDataService.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 02/07/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/**
 CoreDataPersistedDataService is a PersistedDataService which responsible to provide 
 coredata operation on Place entity such as create, fetch and delete all.
 */
class CoreDataPersistedDataService: PersistedDataService {
    

    func deleteAllRecordsFromPlaceEntity() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        do {
            let places  = try context.fetch(fetchRequest)
            for place in places {
                context.delete(place as! NSManagedObject)
            }
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    func fetchAllRecordsFromPlaceEntity() -> [Place] {
        var places: [Place] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Place")
        do {
            let placesManagedObject  = try context.fetch(fetchRequest)
            
            //safe to force casting all entity into Place managed object
            places = placesManagedObject.map{$0 as! Place}
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return places
    }
    
    func createPlacesInPlaceEntity(usingPlaceViewModels viewModels: [PlaceViewModel]) {
       
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        for placeViewModel in viewModels {
            let entity = NSEntityDescription.entity(forEntityName: "Place", in: context)!
            let place = NSManagedObject(entity: entity, insertInto: context) as! Place
            place.name = placeViewModel.name
            place.address = placeViewModel.address
            place.placeId = placeViewModel.placeId
            place.lat = placeViewModel.coordinate.latitude
            place.long = placeViewModel.coordinate.longitude
            place.iconUrl = placeViewModel.iconUrl
            place.photoReference = placeViewModel.photoReference
            place.photoHeight = placeViewModel.photoHeight
            place.photoWidth = placeViewModel.photoWidth
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }

    }

}
