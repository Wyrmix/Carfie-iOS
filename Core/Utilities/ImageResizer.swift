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
    func resize(forUpload image: UIImage, withCompressionQualtiy compressionQuality: CGFloat) -> Data? {
        guard let imageBytes = image.pngData()?.count else {
            // Something is wrong with the image data.
            // TODO: some error handling
            return image.pngData()
        }
        
        // convert image count to kilobytes to make my life easier.
        let imageKiloBytes = imageBytes / 1000
        
        // if the image is smaller than 2 MB we don't need to resize.
        guard imageKiloBytes > 2000 else { return image.pngData() }
        
        // Compression quality should be less than 100%
        guard compressionQuality <= 1.0 else {
            assertionFailure("Compression requires reduce the image size below 100%")
            return nil
        }
        
        return image.jpegData(compressionQuality: compressionQuality)
    }
}
