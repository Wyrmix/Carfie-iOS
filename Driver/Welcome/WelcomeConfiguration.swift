//
//  WelcomeConfiguration.swift
//  Driver
//
//  Created by Christopher Olsen on 10/27/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct WelcomeConfiguration {
    private static let theme: AppTheme = .driver
    
    let viewControllers: [UIViewController & OnboardingScreen] = [
        WelcomeCarouselViewController.viewController(theme: WelcomeConfiguration.theme),
//        CarfieSignUpViewController.viewController(theme: WelcomeConfiguration.theme),
//        LocationPermissionsViewController.viewController(theme: WelcomeConfiguration.theme),
        DocumentsViewController.viewController(),
    ]
}
