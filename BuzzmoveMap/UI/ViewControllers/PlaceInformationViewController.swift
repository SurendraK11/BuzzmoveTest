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
        self.placeImageView.imageFromServerURL(urlString: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(self.place.photoWidth)&maxheight=\(self.place.photoHeight)&photoreference=\(self.place.photoReference)&key=\(apiKey)")
    }
}
