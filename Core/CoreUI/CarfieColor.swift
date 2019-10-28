//
//  CarfieColor.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/2/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

// MARK: - UIColor Extension that contains all Carfie brand colors
extension UIColor {

    /// Convenience function that handles cconverting RGB components of values 0-255 to CGFloats of values 0.0-1.0.
    ///
    /// - Parameters:
    ///   - components: tuple of RGB components
    ///   - alpha: alpha value (defaults to 1.0)
    /// - Returns: UIColor object created via RGB
    private static func fromRGB(components: (red: CGFloat, green: CGFloat, blue: CGFloat), andAlpha alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: components.red/255, green: components.green/255, blue: components.blue/255, alpha: alpha)
    }

    // TODO: remove all references to this.
    /// Legacy color, do not use.
    static let carfieBlue = UIColor.fromRGB(components: (49, 153, 215))
    
    /// Carfie orange color. Primary button color for the Driver app.
    static let carfieOrange = UIColor.fromRGB(components: (245, 108, 64))
    
    /// Carfie fuscia color. Primary button color for the Rider app.
    static let carfieFuscia = UIColor.fromRGB(components: (167, 35, 111))
    
    /// Carfie yellow color.
    static let carfieYellow = UIColor.fromRGB(components: (247, 220, 105))
    
    /// Carfie teal color.
    static let carfieTeal = UIColor.fromRGB(components: (46, 149, 153))
    
    /// Carfie dark gray color.
    static let carfieDarkGray = UIColor.fromRGB(components: (34, 34, 34))
    
    /// Carfie light gray color.
    static let carfieMidGray = UIColor.fromRGB(components: (69, 69, 69))
    
    /// Carfie light gray color.
    static let carfieLightGray = UIColor.fromRGB(components: (123, 123, 123))
}
