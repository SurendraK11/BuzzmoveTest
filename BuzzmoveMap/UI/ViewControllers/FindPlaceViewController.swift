//
//  FindPlaceViewController.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 30/06/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class FindPlaceViewController: UIViewController {
    
    @IBOutlet weak var placeTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var searchResults: [PlaceViewModel] = []
    
    let placeCellIdentifier = "PlaceCellIdentifier"
    let placeSearchService : PlaceSearchService
    
    init(placeSearchService: PlaceSearchService) {
        self.placeSearchService = placeSearchService
        super.init(nibName: "FindPlaceView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Search Place"
        let cellNib = UINib(nibName: "PlaceCell", bundle: nil)
        self.placeTableView.register(cellNib, forCellReuseIdentifier: self.placeCellIdentifier)
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViews()
    }
    
    fileprivate func updateViews(){
        self.mapView.addAnnotations(self.searchResults)
        self.placeTableView.reloadData()
    }
    
    //MARK: - Coredata operation
    
    private func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Place")
        do {
            let places  = try context.fetch(fetchRequest)
            var placeViewModelArray: [PlaceViewModel] = []
            for place in places {
                //Safe to force casting of place managed object
                placeViewModelArray.append(PlaceViewModel(place: place as! Place))
            }
            self.searchResults = placeViewModelArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    fileprivate func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        self.deleteAllRecords()
        let context = appDelegate.managedObjectContext
        
        for placeViewModel in self.searchResults {
            let entity = NSEntityDescription.entity(forEntityName: "Place", in: context)!
            let place = NSManagedObject(entity: entity, insertInto: context)
            place.setValue(placeViewModel.name, forKeyPath: "name")
            place.setValue(placeViewModel.address, forKeyPath: "address")
            place.setValue(placeViewModel.placeId, forKeyPath: "placeId")
            place.setValue(placeViewModel.coordinate.latitude, forKeyPath: "lat")
            place.setValue(placeViewModel.coordinate.longitude, forKeyPath: "log")
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }

        }
        
    }
    
    private func deleteAllRecords()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.managedObjectContext
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

}

// MARK: - search bar delegate

extension FindPlaceViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        self.placeSearchService.getPlaceSearchResults(searchTerm: searchText) {
            [weak self] (results, errorMessage) in
            if let results = results {
                self?.searchResults = results
                self?.updateViews()
                // avoid freezing UI - do database operation async and that
                // has to be on main queue
                DispatchQueue.main.async {
                    self?.saveData()
                }
            }
        }
    }
}

// MARK: - table view delegate and datasource

extension FindPlaceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.placeCellIdentifier, for:  indexPath)
        if let placeCell = cell as? PlaceCell {
            let place = self.searchResults[indexPath.row]
            placeCell.configureCell(name: place.name, address: place.address)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placeInformationViewController = PlaceInformationViewController(place: self.searchResults[indexPath.row])
        self.navigationController?.pushViewController(placeInformationViewController, animated: true)
    }

}


// MARK: - map view delegate

extension FindPlaceViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? PlaceViewModel {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let placeInformationViewController = PlaceInformationViewController(place: view.annotation as! PlaceViewModel)
        self.navigationController?.pushViewController(placeInformationViewController, animated: true)
    }
}
