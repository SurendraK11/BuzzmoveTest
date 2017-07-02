//
//  PlaceCell.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 01/07/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configureCell(name: String, address: String, iconUrl: String?)  {
        self.name.text = name
        self.address.text = address
        self.iconImageView.imageFromServerURL(urlString: iconUrl)
    
    }
    
    override func prepareForReuse() {
        self.name.text = ""
        self.address.text = ""
        self.iconImageView.image = nil
    }
}
