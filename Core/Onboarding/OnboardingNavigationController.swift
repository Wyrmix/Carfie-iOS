//
//  OnboardingNavigationController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// The navigation controller responsible for the onboarding flow.
final class OnboardingNavigationController: UINavigationController {
    static func navigationController(for interactor: OnboardingInteractor) -> OnboardingNavigationController {
        let navigationController = OnboardingNavigationController(interactor: interactor)
        interactor.onboardingNavigationController = navigationController
        return navigationController
    }
    
    private let interactor: OnboardingInteractor
    
    private init(interactor: OnboardingInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        guard let firstViewController = interactor.viewControllers.first else {
            fatalError("No onboarding view controllers.")
        }
        
        self.viewControllers = [firstViewController]
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}
