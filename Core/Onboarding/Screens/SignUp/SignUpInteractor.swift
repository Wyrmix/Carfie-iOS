//
//  SignUpInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

typealias ScrollViewPosition = (insets: UIEdgeInsets, frame: CGRect)

/// Delegate for communicating between the SignUpInteractor and the SignUpViewController..
protocol SignUpInteractorDelegate: class {
    
    /// Asks the view controller to adjust its scroll view for the keyboard.
    /// - Parameter scrollViewPosition: new content insets for the scroll view
    /// - Parameter viewToScroll: view that should be scrolled above the keyboard
    func adjustScrollViewForKeyboard(_ scrollViewPosition: ScrollViewPosition, and viewToScroll: UIView?)
}

/// Interactor for the Sign Up experience.
class SignUpInteractor {
    weak var viewController: (CarfieSignUpViewController & SignUpInteractorDelegate)?
    
    /// Text field that is currently being edited by the use
    private var activeTextInputView: CarfieTextInputView?
    
    private let authController: AuthController
    private let theme: AppTheme
    private let networkService: NetworkService
    private let profileService: ProfileService
    
    var signUpViewPresenter: SignUpViewPresenter?
    
    init(theme: AppTheme,
         networkService: NetworkService = DefaultNetworkService(),
         profileService: ProfileService = DefaultProfileService()
    ) {
        self.authController = DefaultAuthController.shared(theme)
        self.theme = theme
        self.networkService = networkService
        self.profileService = profileService
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - SignUpViewDelegate
extension SignUpInteractor: SignUpViewDelegate {
    func textFieldDidBeginEditing(_ textInputView: CarfieTextInputView) {
        activeTextInputView = textInputView
    }
    
    func textFieldDidEndEditing(_ textInputView: CarfieTextInputView) {
        activeTextInputView = nil
    }
    
    func signUpRequested(with item: SignUpViewState) {
        var validatedSignUp: ValidatedSignUp
        
        do {
            validatedSignUp = try validateSignUpItem(item).resolve()
        } catch {
            // TODO: something with the error
            return
        }
        
        authController.signUp(with: validatedSignUp) { [weak self] result in
            switch result {
            case .success:
                self?.getNewUserProfile()
            case .failure:
                // TODO: show error message and retry
                break
            }
        }
    }
    
    func verifyEmailAvailability(_ items: (email: String?, confirmation: String?)) {
        do {
            let emailResult = try EmailValidator().validate(items.email).resolve()
            _ = try MatchingFieldValidator(fieldToMatch: emailResult).validate(items.confirmation).resolve()
            verifyEmailAvailability(emailResult)
        } catch {
            // TODO: something with the error
        }
    }
    
    private func verifyEmailAvailability(_ email: String) {
        let request = VerifyEmailRequest(email: email)
        networkService.request(request) { [weak self] result in
            guard let self = self else { return }
            
            do {
                // Do nothing on success. Email is good to use.
                _ = try result.resolve()
            } catch {
                self.signUpViewPresenter?.present(emailInUseMessage: SignUp.ErrorMessage.emailAlreadyInUse)
            }
        }
    }
    
    private func validateSignUpItem(_ item: SignUpViewState) -> Result<ValidatedSignUp> {
        do {
            let firstNameResult = try EmptyFieldValidator().validate(item.firstName).resolve()
            let lastNameResult = try EmptyFieldValidator().validate(item.lastName).resolve()
            let phoneNumberResult = try PhoneValidator().validate(item.phone).resolve()
            let emailResult = try EmailValidator().validate(item.email).resolve()
            let passwordResult = try PasswordValidator().validate(item.password).resolve()
            let passwordConfirmationResult = try MatchingFieldValidator(fieldToMatch: passwordResult).validate(item.confirmPassword).resolve()
            
            // ensure email fields match
            _ = try MatchingFieldValidator(fieldToMatch: emailResult).validate(item.confirmEmail).resolve()
            
            let validatedSignUp = ValidatedSignUp(
                firstName: firstNameResult,
                lastName: lastNameResult,
                email: emailResult,
                mobile: phoneNumberResult,
                password: passwordResult,
                passwordConfirmation: passwordConfirmationResult
            )
            return Result.success(validatedSignUp)
            
        } catch {
            return Result.failure(error)
        }
    }
    
    private func getNewUserProfile() {
        profileService.getProfile(theme: theme) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let profile = try result.resolve()
                self.viewController?.onboardingDelegate?.onboardingScreen(didFetchUserProfile: profile)
                self.viewController?.onboardingDelegate?.onboardingScreenComplete()
            } catch {
                // TODO: handle error. maybe retry?
            }
        }
    }
}

extension SignUpInteractor {
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardSize.cgRectValue
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        viewController?.adjustScrollViewForKeyboard((insets: contentInsets, frame: keyboardFrame), and: activeTextInputView)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        viewController?.adjustScrollViewForKeyboard((insets: .zero, frame: .zero), and: nil)
    }
}
