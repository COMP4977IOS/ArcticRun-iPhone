//
//  PhotoThumbNail.swift
//  ArcticRunTemplate
//
//  Created by Jox Toyod on 2016-03-16.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {
    
    @IBOutlet var imgView : UIImageView!
    
    
    func setThumbnailImage(thumbnailImage: UIImage){
        self.imgView.image = thumbnailImage
    }

}