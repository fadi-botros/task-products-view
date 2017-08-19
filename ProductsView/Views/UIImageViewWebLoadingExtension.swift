//
//  ImageViewExtension.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

var cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()

extension UIImageView {
    var imageURL: String? {
        get {
            return nil
        }
        set(value) {
            guard let imageURL = value else { return }
            if let cachedImage = cache.object(forKey: imageURL as NSString) {
                self.image = cachedImage
                return
            }
            if let url = URL(string: imageURL) {
                self.image = UIImage()
                URLSession(configuration: .default).dataTask(with: url) {
                    data, _, error in
                    if let err = error {
                        print(err)
                        return
                    }
                    if let data = data {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                cache.setObject(image, forKey: imageURL as NSString)
                                self.image = image
                            }
                        }
                    }
                }.resume()
            }
        }
    }
}
