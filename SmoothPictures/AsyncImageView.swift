//
//  AsyncImageView.swift
//  SmoothPictures
//
//  Created by O.Ohorbach on 10/25/16.
//  Copyright © 2016 O.Ohorbach. All rights reserved.
//

import Foundation
import UIKit

typealias ImageCacheType = NSCache<NSString, UIImage>

class ImageCache {
    static let shared: ImageCacheType = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ImageCache"
        cache.countLimit = 100
        cache.totalCostLimit = 100*1024*1024
        
        return cache
    }()
}

class AsyncImageView: UIImageView {
    var imageURL: URL?
    var imageDataTask: URLSessionDataTask?
    
    func loadImage(withURL url: URL, cache: ImageCacheType) {
        imageURL = url
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
        } else {
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    self.imageDataTask = nil
                    cache.setObject(image, forKey: url.absoluteString as NSString, cost: data.count)
                    if let responseURL = response?.url, responseURL == self.imageURL {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }
            imageDataTask = dataTask
            dataTask.resume()
        }
    }
    
    func cancelImageLoad() {
        imageDataTask?.cancel()
    }
}



