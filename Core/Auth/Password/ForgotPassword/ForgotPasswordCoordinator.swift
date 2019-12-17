//
//  ForgotPasswordCoordinator.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct ForgotPasswordViewState {
    var checkEmailRequestInProgress: Bool = false
}

class ForgotPasswordCoordinator {
    weak var viewController: NewForgotPasswordViewController?
    
    var presenter: ForgotPasswordPresenter?
    
    let passwordService: PasswordService
    var viewState: ForgotPasswordViewState {
        didSet {
            presenter?.present(viewState: viewState)
        }
    }
    
    init(passwordService: PasswordService = DefaultPasswordService()) {
        self.passwordService = passwordService
        self.viewState = ForgotPasswordViewState()
    }
    
    func start() {}
    
    func checkEmail(_ email: String?) {
        do {
            let email = try EmailValidator().validate(email).resolve()
            requestOTP(forEmail: email)
        } catch {
            return
        }
    }
    
    private func requestOTP(forEmail email: String) {
        viewState.checkEmailRequestInProgress = true
        
        passwordService.requestPasswordResetOTP(forEmail: email) { [weak self] result in
            self?.viewState.checkEmailRequestInProgress = false
            
            do {
                let response = try result.resolve()
                self?.presentChangePassword(for: response.user)
            } catch {
                UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: self?.viewController)
            }
        }
    }
    
    private func presentChangePassword(for profile: CarfieProfile) {
        let changePasswordViewController = ChangePasswordViewController.viewController(for: .forgot, and: profile)
        viewController?.navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
}
