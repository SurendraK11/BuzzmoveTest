//
//  UIImageView+Extension.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 01/07/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromServerURL(urlString: String?) {
        guard let urlString = urlString,  let url =  URL(string: urlString) else {
            //we can do fallback icon
            return
        }
        //Session dataTask executes on background
        URLSession.shared.dataTask(with: url, completionHandler: {
            [weak self] (data, _, error) -> Void in
            if error != nil {
                //we can do fallback icon
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data!)
            }
        }).resume()
    }
}
