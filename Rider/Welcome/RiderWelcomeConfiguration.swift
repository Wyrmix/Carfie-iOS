//
//  WelcomeConfiguration.swift
//  Rider
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct RiderWelcomeConfiguration: WelcomeConfiguration {
    var viewControllers: [UIViewController & OnboardingScreen] {
        return [
            WelcomeCarouselViewController.viewController(theme: .rider),
            CarfieSignUpViewController.viewController(theme: .rider),
            LocationPermissionsViewController.viewController(theme: .rider),
        ]
    }
    
    var loginViewController: LoginViewController {
        return LoginViewController.viewController(for: .rider)
    }
    
    let postLoginHandler: ((CarfieProfile) -> Void)?
}
