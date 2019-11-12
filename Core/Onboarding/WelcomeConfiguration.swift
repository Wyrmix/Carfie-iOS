//
//  WelcomeConfiguration.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol WelcomeConfiguration {
    var viewControllers: [UIViewController & OnboardingScreen] { get }
    var loginViewController: LoginViewController { get }
    var postLoginHandler: ((CarfieProfile) -> Void)? { get }
}
