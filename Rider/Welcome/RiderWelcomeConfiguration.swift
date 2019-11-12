//
//  WelcomeConfiguration.swift
//  Rider
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct RiderWelcomeConfiguration: WelcomeConfiguration {
    let viewControllers: [UIViewController & OnboardingScreen] = [
        WelcomeCarouselViewController.viewController(theme: .rider),
        CarfieSignUpViewController.viewController(theme: .rider),
        LocationPermissionsViewController.viewController(theme: .rider),
    ]
    
    let loginViewController = LoginViewController.viewController(for: .rider)
    
    let postLoginHandler: ((CarfieProfile) -> Void)?
}
