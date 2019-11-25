//
//  WelcomeConfiguration.swift
//  Driver
//
//  Created by Christopher Olsen on 10/27/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct DriverWelcomeConfiguration: WelcomeConfiguration {
    var viewControllers: [UIViewController & OnboardingScreen] {
        return [
            WelcomeCarouselViewController.viewController(theme: .driver),
            CarfieSignUpViewController.viewController(theme: .driver),
            DriverIdentificationViewController.viewController(),
            LocationPermissionsViewController.viewController(theme: .driver),
            DocumentsViewController.viewController(),
        ]
    }
    
    var loginViewController: LoginViewController {
        return LoginViewController.viewController(for: .driver)
    }
    
    let postLoginHandler: ((CarfieProfile) -> Void)?
}
