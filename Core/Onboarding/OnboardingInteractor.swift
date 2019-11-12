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
    /// Indicates that the user has completed all necessary steps for an onboarding screen.
    func onboardingScreenComplete()
    
    /// Indicates that the user wants to login with an existing account (effectively bypassing onboarding).
    func launchLogin()
    
    /// Indicates that the user wants to return to the previous screen.
    func returnToWelcome()
    
    func onboardingScreen(didFetchUserProfile profile: CarfieProfile)
}

/// Delegate for communicating between the OnboardingInteractor and the login screen.
protocol LoginScreenDelegate: class {
    /// Login completed successfully.
    func loginComplete(with profile: CarfieProfile)
    
    /// User cancelled the login action.
    func loginCancelled()
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
    
    /// The view controller for login, exists parallel to the onboarding stack
    let loginViewController: LoginViewController
    
    /// Closure to be called after login is complete. This exists to plumb things back into the individual app targets. Hopefully
    /// this can eventually be removed once tech debt around the User object is addressed.
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
            
            // if set to zero then pop to root, otherwise show relevant controller
            if onboardingIndex == 0 {
                onboardingNavigationController?.popToRootViewController(animated: true)
            } else {
                onboardingNavigationController?.pushViewController(viewControllers[onboardingIndex], animated: true)
            }
        }
    }
    
    /// Create a new instance of a OnboardingInteractor.
    /// - Parameter onboardingViewControllers: A complete array of all view controllers needed for onboarding.
    /// - Parameter loginViewController: view controller to display for login.
    /// - Parameter postLoginHandler: completion block that is called after login/sign up is successful.
    init(configuration: WelcomeConfiguration) {
        self.viewControllers = configuration.viewControllers
        self.loginViewController = configuration.loginViewController
        self.postLoginHandler = configuration.postLoginHandler
        self.viewControllers.first?.onboardingDelegate = self
        
        loginViewController.interactor.delegate = self
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
        onboardingNavigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func returnToWelcome() {
        onboardingIndex = 0
    }
    
    func onboardingScreen(didFetchUserProfile profile: CarfieProfile) {
        postLoginHandler?(profile)
    }
}

// MARK: - LoginScreenDelegate
extension OnboardingInteractor: LoginScreenDelegate {
    func loginComplete(with profile: CarfieProfile) {
        postLoginHandler?(profile)
        onboardingComplete()
    }
    
    func loginCancelled() {
        onboardingIndex = 0
    }
}
