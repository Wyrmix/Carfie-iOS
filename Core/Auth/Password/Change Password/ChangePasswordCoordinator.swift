//
//  ChangePasswordCoordinator.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

enum ChangePasswordType {
    case forgot
    case update
}

struct ChangePasswordViewState {
    let changeType: ChangePasswordType
    let profile: CarfieProfile
    
    var updatePasswordRequestInProgress: Bool = false
    
    var oldPasswordInputViewTitle: String {
        switch changeType {
        case .forgot:
            return "Enter your One-Time Password (OTP)"
        case .update:
            return "Old Password"
        }
    }
}

class ChangePasswordCoordinator {
    weak var viewController: ChangePasswordViewController?
    
    /// Text field that is currently being edited by the use
    private var activeTextInputView: CarfieTextInputView?
    
    var presenter: ChangePasswordPresenter?
    
    var viewState: ChangePasswordViewState {
        didSet {
            presenter?.present(viewState)
        }
    }
    
    private let passwordService: PasswordService
    
    init(
        passwordService: PasswordService = DefaultPasswordService(),
        changeType: ChangePasswordType,
        profile: CarfieProfile
    ) {
        self.passwordService = passwordService
        self.viewState = ChangePasswordViewState(changeType: changeType, profile: profile)
    }
    
    func start() {
        addObservers()
        presenter?.present(viewState)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func updatePassword(old: String?, new: String?, confirm: String?) {
        do {
            let oldPassword = try EmptyFieldValidator().validate(old).resolve()
            let newPassword = try PasswordValidator().validate(new).resolve()
            let confirmPassword = try MatchingFieldValidator(fieldToMatch: newPassword).validate(confirm).resolve()
            
            viewState.updatePasswordRequestInProgress = true
            
            switch viewState.changeType {
            case .forgot:
                resetPassword(otp: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword)
            case .update:
                changePassword(oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword)
            }
        } catch {
            return
        }
    }
    
    private func resetPassword(otp: String, newPassword: String, confirmPassword: String) {
        passwordService.resetPassword(forUserId: viewState.profile.id, otp: otp, toNewPassword: newPassword, withConfirmation: confirmPassword) { [weak self] result in
            self?.viewState.updatePasswordRequestInProgress = false
            
            switch result {
            case .success:
                self?.showSuccessAlert()
            case .failure:
                return
            }
        }
    }
    
    private func changePassword(oldPassword: String, newPassword: String, confirmPassword: String) {
        passwordService.changePassword(oldPassword, toNewPassword: newPassword, withConfirmation: confirmPassword) { [weak self] result in
            self?.viewState.updatePasswordRequestInProgress = false
            
            switch result {
            case .success:
                self?.showSuccessAlert()
            case .failure:
                return
            }
        }
    }
    
    private func showSuccessAlert() {
        UserFacingErrorIntent(title: "Success", message: "Your password was successfully updated.", action: { _ in
            self.viewController?.dismiss(animated: true)
        }).execute(via: viewController)
    }
}

// MARK: - CarfieTextInputViewDelegate
extension ChangePasswordCoordinator: CarfieTextInputViewDelegate {
    func textInputViewDidBeginEditing(_ textInputView: CarfieTextInputView) {
        activeTextInputView = textInputView
    }
    
    func textInputViewDidEndEditing(_ textInputView: CarfieTextInputView) {
        _ = textInputView.validate()
        activeTextInputView = nil
    }
    
    func textInputViewShouldReturn(_ textInputView: CarfieTextInputView) -> Bool {
        _ = textInputView.validate()
        textInputView.resignTextFieldFirstResponder()
        return true
    }
}

// MARK: - Keyboard Management
extension ChangePasswordCoordinator {
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
