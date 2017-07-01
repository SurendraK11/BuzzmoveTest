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
    
    func configureCell(name: String, address: String)  {
        self.name.text = name
        self.address.text = address
    }
    
    override func prepareForReuse() {
        self.name.text = ""
        self.address.text = ""
    }
}
