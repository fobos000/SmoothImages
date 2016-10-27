//
//  ImageDataSource.swift
//  SmoothPictures
//
//  Created by Ostap Horbach on 10/24/16.
//  Copyright © 2016 O.Ohorbach. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDataSourceOutput: class {
    func didUpdate()
}

class ImageDataSource: NSObject {
    
    let PreloadDeltaMultiplier: Float = 0.5

    weak var output: ImageDataSourceOutput?
    
    let imageLoader: ImageLoader
    let imageCache: ImageCacheType
    
    init(imageLoader: ImageLoader, imageCache: ImageCacheType) {
        self.imageLoader = imageLoader
        self.imageCache = imageCache
        
        super.init()
        NotificationCenter.default.addObserver(forName: .UIApplicationDidReceiveMemoryWarning, object: nil, queue: OperationQueue.main) {_ in 
            self.imageCache.removeAllObjects()
        }
    }
    
    fileprivate func shouldStartPreload(forIndexPath indexPath: IndexPath, currentPage: Int) -> Bool {
        let preloadIndexDelta = Int(Float(imageLoader.itemsPerPage) * PreloadDeltaMultiplier)
        return (indexPath.row == (currentPage * imageLoader.itemsPerPage) - preloadIndexDelta)
    }
}

extension ImageDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ImageCell
        cell.rowLabel.text = String(indexPath.row)
        let imageUrl = imageLoader.loadedImageURLs[indexPath.row]
        cell.pictureView.loadImage(withURL: imageUrl, cache: imageCache)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageLoader.loadedImageURLs.count
    }
}

extension ImageDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let currentPage = imageLoader.currentPage {
            if shouldStartPreload(forIndexPath: indexPath, currentPage: currentPage) {
                imageLoader.load(page: currentPage + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let imageCell = cell as! ImageCell
        imageCell.pictureView?.cancelImageLoad()
    }
}

extension ImageDataSource: ImageLoderOutput {
    func didLoadPage(page: Int) {
        output?.didUpdate()
    }
}
