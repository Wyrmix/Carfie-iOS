//
//  MockWelcomeConfiguration.swift
//  CoreTests
//
//  Created by Christopher Olsen on 11/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct MockWelcomeConfiguration: WelcomeConfiguration {
    let viewControllers: [UIViewController & OnboardingScreen]
    let loginViewController: LoginViewController
    let postLoginHandler: ((CarfieProfile) -> Void)?
    
    init(viewControllers: [UIViewController & OnboardingScreen] = [MockOnboardingScreen(withTitle: "Screen")],
         loginViewController: LoginViewController  = LoginViewController.viewController(for: .rider),
         postLoginHandler: ((CarfieProfile) -> Void)? = nil)
    {
        self.viewControllers = viewControllers
        self.loginViewController = loginViewController
        self.postLoginHandler = postLoginHandler
    }
}
