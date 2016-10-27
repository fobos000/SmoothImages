//
//  ImageLoader.swift
//  SmoothPictures
//
//  Created by Ostap Horbach on 10/24/16.
//  Copyright © 2016 O.Ohorbach. All rights reserved.
//

import Foundation

protocol ImageLoderOutput: class {
    func didLoadPage(page: Int)
}

class ImageLoader {
    let searchURLFormat = "https://api.500px.com/v1/photos?feature=editors&page=%d&image_size=600&consumer_key=n7SYrmrbzsqnJppRPYZMk1ZCPZsXQfeROS0juhCx"
    
    weak var output: ImageLoderOutput?
    
    var loadedImageURLs = [URL]()
    var currentPage: Int?
    var totalPages: Int?
    var totalItems: Int?
    let itemsPerPage = 20
    
    fileprivate var currentlyLoading = false
    
    func load(page: Int) {
        if currentlyLoading {
            return
        }
        currentlyLoading = true
        let pageURL = urlForPage(page: page)
        URLSession.shared.dataTask(with: pageURL) { (data, response, error) in
            if let data = data {
                self.handleResponse(with: data, page: page)
            }
            self.currentlyLoading = false
        }.resume()
    }
    
    fileprivate func urlForPage(page: Int) -> URL {
        return URL(string: String(format: searchURLFormat, page))!
    }
    
    fileprivate func handleResponse(with data: Data, page: Int) {
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        
        currentPage = json.value(forKey: "current_page") as? Int
        totalPages = json.value(forKey: "total_pages") as? Int
        totalItems = json.value(forKey: "total_items") as? Int
        
        let imageURLs = urlsWithData(json: json)
        loadedImageURLs.append(contentsOf: imageURLs)
        DispatchQueue.main.async {
            self.output?.didLoadPage(page: page)
        }
    }
    
    fileprivate func urlsWithData(json: NSDictionary) -> [URL] {
        let photos = json.value(forKey: "photos") as! NSArray
        let imageURLs = photos.value(forKey: "image_url") as! Array<String>
        let urls = imageURLs.map { URL(string: $0)! }
        
        return urls
    }
}
