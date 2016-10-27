//
//  ImageCell.swift
//  SmoothPictures
//
//  Created by O.Ohorbach on 10/25/16.
//  Copyright © 2016 O.Ohorbach. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var pictureView: AsyncImageView!
    @IBOutlet weak var rowLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.image = nil
        rowLabel.text = ""
    }
}
