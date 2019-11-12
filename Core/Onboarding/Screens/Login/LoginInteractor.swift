//
//  LoginInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class LoginInteractor {
    weak var viewController: LoginViewController?
    weak var delegate: LoginScreenDelegate?
    
    private let theme: AppTheme
    private var authController: AuthController
    private let profileService: ProfileService
    
    init(theme: AppTheme, profileService: ProfileService = DefaultProfileService()) {
        self.theme = theme
        self.authController = DefaultAuthController.shared(theme)
        self.profileService = profileService
        
        self.authController.loginDelegate = self
    }
    
    func login(email: String?, password: String?) {
        guard let email = email, let password = password else { return }
        
        viewController?.animateNetworkActivity(true)
        authController.loginWithCarfie(Login(email: email, username: email, password: password))
    }
    
    func cancelLogin() {
        delegate?.loginCancelled()
    }
    
    private func getUserProfile() {
        profileService.getProfile(theme: theme) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let profile = try result.resolve()
                self.delegate?.loginComplete(with: profile)
            } catch {
                self.viewController?.animateNetworkActivity(false)
                UserFacingErrorIntent(title: "Something went wrong.", message: "Please try again.").execute(via: self.viewController)
            }
        }
    }

}

extension LoginInteractor: AuthControllerLoginDelegate {
    func authController(_ authController: AuthController, loginDidCompleteWith result: AuthResult) {
        switch result {
        case .success:
            getUserProfile()
        case .failure:
            viewController?.animateNetworkActivity(false)
            UserFacingErrorIntent(title: "Something went wrong.", message: "User credentials are incorrect.").execute(via: viewController)
        case .cancel:
            viewController?.animateNetworkActivity(false)
        }
    }
}
