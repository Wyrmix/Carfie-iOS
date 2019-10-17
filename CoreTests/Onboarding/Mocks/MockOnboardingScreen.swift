//
//  OnboardingScreenMock.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class MockOnboardingScreen: UIViewController, OnboardingScreen {
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    init(withTitle title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}
