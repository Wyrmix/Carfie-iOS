//
//  WelcomeConfiguration.swift
//  Driver
//
//  Created by Christopher Olsen on 10/27/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct DriverWelcomeConfiguration: WelcomeConfiguration {
    let viewControllers: [UIViewController & OnboardingScreen] = [
        WelcomeCarouselViewController.viewController(theme: .driver),
        CarfieSignUpViewController.viewController(theme: .driver),
        LocationPermissionsViewController.viewController(theme: .driver),
        DocumentsViewController.viewController(),
    ]
    
    let loginViewController = LoginViewController.viewController(for: .driver)
    
    let postLoginHandler: ((CarfieProfile) -> Void)?
}
