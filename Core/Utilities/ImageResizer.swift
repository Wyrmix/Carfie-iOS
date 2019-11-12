//
//  ImageResizer.swift
//  Driver
//
//  Created by Christopher Olsen on 11/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

import func AVFoundation.AVMakeRect

struct ImageResizer {
    func resize(forUpload image: UIImage) -> Data? {
        guard let imageBytes = image.pngData()?.count else {
            // Something is wrong with the image data.
            // TODO: some error handling
            return image.pngData()
        }
        
        // convert image count to kilobytes to make my life easier.
        let imageKiloBytes = imageBytes / 1000
        
        // if the image is smaller than 2 MB we don't need to resize.
        guard imageKiloBytes > 2000 else { return image.pngData() }
        
        // 80% jpeg compression should be more than enough to reduce any iPhone image
        // to less than 2 MB, but this should be re-investigated at some point.
        return image.jpegData(compressionQuality: 0.8)
    }
}
