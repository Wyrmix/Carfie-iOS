//
//  WelcomeConfiguration.swift
//  Rider
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct WelcomeConfiguration {
    private static let theme: AppTheme = .rider
    
    let viewControllers: [UIViewController & OnboardingScreen] = [
        WelcomeCarouselViewController.viewController(theme: WelcomeConfiguration.theme),
        CarfieSignUpViewController.viewController(theme: WelcomeConfiguration.theme),
        LocationPermissionsViewController.viewController(theme: WelcomeConfiguration.theme),
    ]
}
