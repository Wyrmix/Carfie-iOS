//
//  RootContainerInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/8/19.
//  Copyright © 2019 espy. All rights reserved.
//

import UIKit

/// Delegate protocol for communicating updates from the RootContainerInteractor
protocol RootContainerInteractorDelegate: class {
    func onboardingDidComplete()
}

/// Root Interactor for the app. Encapsulates logic for setting and displaying "Root" experiences:
/// - Home Drawer Controller
/// - Login/Onboarding
final class RootContainerInteractor {
    
    weak var delegate: RootContainerInteractorDelegate?
    
    /// This is the root view controller for main app functionality.
    let rootViewController = UIViewController()
    
    /// This property exists for state testing. Though it may be valuable for other features in the future.
    var isPresentingLoginExperience: Bool?
    
    /// The current child view controller contained by the root view controller.
    private var childViewController: UIViewController?
    
    /// The default login view controller to show on login and logout after the user has completed onboarding.
    private var loginViewController: UIViewController?
    
    // MARK: Init
    
    init() {
        rootViewController.view.backgroundColor = .white
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onboardingDidComplete), name: .OnboardingDidComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: .UserDidLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name: .UserDidLogin, object: nil)
    }
    
    // MARK: Internal
    
    /// Loads the child "main app" view controller and makes it visible.
    func start() {
        loadChildViewController()
    }
    
    /// Preps the login view controller and holds it in memory for presentation.
    /// - Parameter viewController: the login view controller
    func configureLoginViewController(_ viewController: UIViewController) {
        loginViewController = viewController
    }
    
    /// Preps the main child view controller and holds it in memory for presentation.
    /// - Parameter viewController: the main view controller
    func configureChildViewController(_ viewController: UIViewController) {
        childViewController = viewController
    }
    
    /// Presents the logon experience by embedding it in a navigation controller and modally presenting it.
    /// - Parameter animated: determines if the presentation is animated
    /// - Parameter completion: closure to be called after present(_:animated:completion) completes
    func presentLoginExperience(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let loginViewController = loginViewController else {
            return
        }
        
        guard !loginViewController.isBeingPresented else {
            return
        }
        
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.isNavigationBarHidden = true
        
        // ensure full screen presentation of login and onboarding in iOS 13.
        navigationController.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            navigationController.isModalInPresentation = true
        }
        
        rootViewController.present(navigationController, animated: animated) {
            self.isPresentingLoginExperience = true
            self.unloadChildViewController()
            completion?()
        }
    }
    
    /// Dismisses the login experience and starts the main app view controller
    /// - Parameter completion: closure to be called after dismiss(animated:completion:) completes
    func dismissLoginExperience(completion: (() -> Void)? = nil) {
        start()
        rootViewController.dismiss(animated: true) {
            self.isPresentingLoginExperience = false
            completion?()
        }
    }
    
    // MARK: Private
    
    private func loadChildViewController() {
        guard let child = childViewController else { return }
        
        rootViewController.addChild(child)
        child.view.frame = rootViewController.view.frame
        rootViewController.view.addSubview(child.view)
        child.didMove(toParent: rootViewController)
    }
    
    private func unloadChildViewController() {
        guard let child = childViewController else { return }
        
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    // MARK: Selectors
    
    @objc private func onboardingDidComplete() {
        delegate?.onboardingDidComplete()
    }
    
    @objc private func userDidLogin() {
        NotificationCenter.default.removeObserver(self, name: .UserDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: .UserDidLogout, object: nil)
    }
    
    @objc private func userDidLogout() {
        NotificationCenter.default.removeObserver(self, name: .UserDidLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name: .UserDidLogin, object: nil)
        presentLoginExperience()
    }
}
