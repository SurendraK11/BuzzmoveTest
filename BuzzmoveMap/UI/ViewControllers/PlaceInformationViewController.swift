//
//  PlaceInformationViewController.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 30/06/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import UIKit

class PlaceInformationViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    
    let place: PlaceViewModel
    
    init(place: PlaceViewModel) {
        self.place = place
        super.init(nibName: "PlaceInformationView", bundle: nil)
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Place"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.name.text = self.place.name
        self.address.text = self.place.address
        self.address.sizeToFit()
        self.address.numberOfLines = 0
        if let photoReference = self.place.photoReference, let width = self.place.photoWidth, let height = self.place.photoHeight {
            self.placeImageView.imageFromServerURL(urlString: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(width)&maxheight=\(height)&photoreference=\(photoReference)&key=\(apiKey)")
        }
    }
}
