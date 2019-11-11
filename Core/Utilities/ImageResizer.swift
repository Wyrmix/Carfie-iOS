//
//  ImageResizer.swift
//  Driver
//
//  Created by Christopher Olsen on 11/10/19.
//  Copyright © 2019 espy. All rights reserved.
//

import UIKit

import func AVFoundation.AVMakeRect

extension UIImage {
    /// Resize the image.
    /// - Parameter size: size at which to render the image
    func resize(for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: size))
            self.draw(in: rect)
        }
    }
}
