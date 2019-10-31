//
//  SignUpInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

typealias ScrollViewPosition = (insets: UIEdgeInsets, frame: CGRect)

protocol SignUpInteractorDelegate: class {
    func adjustScrollViewForKeyboard(_ scrollViewPosition: ScrollViewPosition, and viewToScroll: UIView?)
}

class SignUpInteractor {
    weak var viewController: (CarfieSignUpViewController & SignUpInteractorDelegate)?
    
    /// Text field that is currently being edited by the use
    private var activeTextInputView: CarfieTextInputView?
    
    init() {
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension SignUpInteractor: SignUpViewDelegate {
    func textFieldDidBeginEditing(_ textInputView: CarfieTextInputView) {
        activeTextInputView = textInputView
    }
    
    func textFieldDidEndEditing(_ textInputView: CarfieTextInputView) {
        activeTextInputView = nil
    }
    
    func signUpRequested(with item: SignUpItem) {
        var validatedSignUp: ValidatedSignUp
        
        do {
            validatedSignUp = try validateSignUpItem(item).resolve()
        } catch {
            // TODO: something with error
        }
        
        // TODO: send values to sign up service
        viewController?.onboardingDelegate?.onboardingScreenComplete()
    }
    
    private func validateSignUpItem(_ item: SignUpItem) -> Result<ValidatedSignUp> {
        do {
            let firstNameResult = try EmptyFieldValidator().validate(item.firstName).resolve()
            let lastNameResult = try EmptyFieldValidator().validate(item.lastName).resolve()
            let emailResult = try EmailValidator().validate(item.email).resolve()
            let passwordResult = try PasswordValidator().validate(item.password).resolve()
            
            // ensure password and email fields match
            _ = try MatchingFieldValidator(fieldToMatch: emailResult).validate(item.confirmEmail).resolve()
            _ = try MatchingFieldValidator(fieldToMatch: passwordResult).validate(item.confirmPassword).resolve()
            
            let validatedSignUp = ValidatedSignUp(
                firstName: firstNameResult,
                lastName: lastNameResult,
                email: emailResult,
                password: passwordResult
            )
            return Result.success(validatedSignUp)
            
        } catch {
            return Result.failure(error)
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
