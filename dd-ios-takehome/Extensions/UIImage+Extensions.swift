//
//  UIImage+Extensions.swift
//  dd-ios-takehome
//
//  Created by Christopher Kelley on 10/27/19.
//  Copyright © 2019 Christopher Kelley. All rights reserved.
//

import UIKit

let cache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func image(url: URL) {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    print(error!.localizedDescription)
                    return
                }

                if let downloadedImage = UIImage(data: data) {
                    cache.setObject(downloadedImage, forKey: url.absoluteString as NSString)

                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
