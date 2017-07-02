//
//  UIImageView+Extension.swift
//  BuzzmoveMap
//
//  Created by Surendra Kumar on 01/07/2017.
//  Copyright © 2017 Surendra Kumar. All rights reserved.
//

import Foundation
import UIKit

/**
 This is extension of UIImageView, provide additional
 feature to fetch image from server asynchronously
 */
extension UIImageView {
    
    ///
    /// This will fetch image data asynchronously for given image url and will set image in
    /// UIImageView
    /// - Parameter urlString: image url
    ///
    public func imageFromServerURL(urlString: String?) {
        guard let urlString = urlString,  let url =  URL(string: urlString) else {
            //we can set fallback icon
            return
        }
        //Session dataTask executes on background, so it wouldn't freeze UI
        URLSession.shared.dataTask(with: url, completionHandler: {
            [weak self] (data, _, error) -> Void in
            if error != nil {
                //we can set fallback icon
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data!)
            }
        }).resume()
    }
}
