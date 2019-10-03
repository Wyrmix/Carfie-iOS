//
//  CarfieColor.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/2/19.
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

    static let carfieBlue = UIColor.fromRGB(components: (49, 153, 215))
}
