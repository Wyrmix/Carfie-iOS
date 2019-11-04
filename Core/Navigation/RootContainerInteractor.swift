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
    
    /// Signals that the root view controller's viewDidLoad() successfully completed. The delegate can
    /// then perform any actions that require the view to be loaded (e.g. present login).
    func rootViewIsLoaded()
    
    /// Signals that onboarding has been completed so the delegate can complete any post-onboarding actions.
    func onboardingDidComplete()
}

/// Delegate for communicating events from the onboading interactor.
protocol OnboardingDelegate: class {
    
    /// Notifies the delegate that the user has completed the onboarding experience.
    func onboardingWillComplete()
    
    /// Notifies the delegate that the user chose to go to login.
    func showLogin()
}

/// Root Interactor for the app. Encapsulates logic for setting and displaying "Root" experiences:
/// - Home Drawer Controller
/// - Login/Onboarding
final class RootContainerInteractor {
    
    weak var delegate: RootContainerInteractorDelegate?
    
    /// This is the root view controller for main app functionality.
    var rootViewController: RootViewController?
    
    /// The current child view controller contained by the root view controller.
    private var childViewController: UIViewController?
    
    /// The default login view controller to show on login and logout after the user has completed onboarding.
    private var loginViewController: UIViewController?
    
    /// The default onboarding experience to show on first launch.
    private var onboardingNavigationController: UINavigationController?
    
    // MARK: Init
    
    init() {
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
    
    func configureRootViewController(_ viewController: RootViewController) {
        rootViewController = viewController
        rootViewController?.delegate = self
        rootViewController?.view.backgroundColor = .white
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
    
    /// Preps the onboarding navigation controller and holds it in memory for presentation.
    /// - Parameter viewController: the onboarding navigation controller
    func configureOnboardingNavigationController(_ navigationController: UINavigationController) {
        onboardingNavigationController = navigationController
    }
    
    /// Presents the onboarding experience by embedding it in a navigation controller and modally presenting it.
    /// - Parameter completion: closure to be called after present(_:animated:completion) completes
    func presentOnboardingExperience(animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let navigationController = onboardingNavigationController else {
            assertionFailure("Presenting onboarding with no onboarding navigation controller.")
            return
        }
        
        // ensure full screen presentation of login and onboarding in iOS 13.
        navigationController.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            navigationController.isModalInPresentation = true
        }
        
        rootViewController?.present(navigationController, animated: animated) {
            self.unloadChildViewController()
            completion?()
        }
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
        
        rootViewController?.present(navigationController, animated: animated) {
            self.unloadChildViewController()
            completion?()
        }
    }
    
    /// Dismisses the onboarding experience and starts the main app view controller
    /// - Parameter completion: closure to be called after dismiss(animated:completion:) completes
    func dismissOnboardingExperience(completion: (() -> Void)? = nil) {
        rootViewController?.dismiss(animated: true) {
            completion?()
        }
    }
    
    /// Dismisses the login experience and starts the main app view controller
    /// - Parameter completion: closure to be called after dismiss(animated:completion:) completes
    func dismissLoginExperience(completion: (() -> Void)? = nil) {
        start()
        rootViewController?.dismiss(animated: true) {
            completion?()
        }
    }
    
    // MARK: Private
    
    private func loadChildViewController() {
        guard let rootViewController = rootViewController,
              let child = childViewController else { return }
        
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
        presentOnboardingExperience(animated: true)
    }
}

extension RootContainerInteractor: RootViewControllerDelegate {
    func rootViewController(_ viewController: RootViewController, isLoaded: Bool) {
        guard isLoaded else { return }
        delegate?.rootViewIsLoaded()
    }
}

extension RootContainerInteractor: OnboardingDelegate {
    func onboardingWillComplete() {
        start()
        dismissOnboardingExperience()
    }
    
    func showLogin() {
        dismissOnboardingExperience {
            self.presentLoginExperience(animated: false)
        }
    }
}
