//
//  OnboardingInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// Delegate for communicating between the OnboardingInteractor and individual onboarding screens.
protocol OnboardingScreenDelegate: class {
    /// Indicates that the user has completed all necessary steps for an onboarding screen
    func onboardingScreenComplete()
    
    /// Indicates that the user wants to login with an existing account (effectively bypassing onboarding).
    func launchLogin()
    
    func onboardingScreen(didFetchUserProfile profile: CarfieProfile)
}

/// An onboarding screen.
protocol OnboardingScreen: class {
    /// Onboarding delegate that communicates user completion status for each screen.
    /*weak*/ var onboardingDelegate: OnboardingScreenDelegate? { get set }
}

/// Central interactor that will control the navigation and interactions necessary to present the complete onboarding experience to the user.
final class OnboardingInteractor {
    
    weak var onboardingNavigationController: OnboardingNavigationController?
    
    weak var delegate: OnboardingDelegate?
    
    /// All view controllers for the Onboarding stack.
    let viewControllers: [UIViewController & OnboardingScreen]
    
    let postLoginHandler: ((CarfieProfile) -> Void)?
    
    /// Index of the currently presented onboarding view controller. Starts at 0 and ends
    /// when onboardingIndex == viewControllers.count.
    private var onboardingIndex: Int = 0 {
        didSet {
            // If we finish with the last controller in the stack then onboarding is complete.
            guard onboardingIndex < viewControllers.count else {
                onboardingComplete()
                return
            }
            viewControllers[onboardingIndex].onboardingDelegate = self
            onboardingNavigationController?.pushViewController(viewControllers[onboardingIndex], animated: true)
        }
    }
    
    /// Create a new instance of a OnboardingInteractor.
    /// - Parameter onboardingViewControllers: A complete array of all view controllers needed for onboarding.
    init(onboardingViewControllers: [UIViewController & OnboardingScreen], postLoginHandler: ((CarfieProfile) -> Void)?) {
        self.viewControllers = onboardingViewControllers
        self.postLoginHandler = postLoginHandler
        self.viewControllers.first?.onboardingDelegate = self
    }
    
    private func onboardingComplete() {
        delegate?.onboardingWillComplete()
    }
}

// MARK: - OnboardingDelegate Implementation
extension OnboardingInteractor: OnboardingScreenDelegate {
    func onboardingScreenComplete() {
        // increment index to set the next active onboarding screen
        onboardingIndex += 1
    }
    
    func launchLogin() {
        delegate?.showLogin()
    }
    
    func onboardingScreen(didFetchUserProfile profile: CarfieProfile) {
        postLoginHandler?(profile)
    }
}
