//
//  AppTheme.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/21/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// Used to inform various shared elements which app (driver or rider) design theme to use.
enum AppTheme {
    case driver
    case rider
    
    /// Gradient background color used for onboarding screens.
    var onboardingGradientColors: [CGColor] {
        switch self {
        case .driver:
            return [UIColor.carfieYellow.cgColor, UIColor.carfieTeal.cgColor]
        case .rider:
            return [UIColor.carfieYellow.cgColor, UIColor.carfieOrange.cgColor]
        }
    }
    
    /// The main hero image used for eachj app flavor.
    var logoImage: UIImage? {
        switch self {
        case .driver:
            return UIImage(named: "driverLogo")
        case .rider:
            return UIImage(named: "riderLogo")
        }
    }
}
