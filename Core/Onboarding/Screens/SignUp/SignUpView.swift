//
//  SignUpView.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol SignUpViewDelegate: class {
    func signUpRequested(with item: SignUpViewState)
    func cancelSignUp()
    func textFieldDidBeginEditing(_ textInputView: CarfieTextInputView)
    func textFieldDidEndEditing(_ textInputView: CarfieTextInputView)
    func verifyEmailAvailability(_ items: (email: String?, confirmation: String?))
}

class SignUpView: UIView {
    
    weak var delegate: SignUpViewDelegate?
    
    private let theme: AppTheme
    
    // MARK: UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .carfieHeading
        label.textColor = .carfieDarkGray
        return label
    }()
    
    private let signUpButton: AnimatedCarfieButton = {
        let button = AnimatedCarfieButton()
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    
    private let cancelButton: CarfieSecondaryButton = {
        let button = CarfieSecondaryButton()
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    // MARK: Input Fields
    
    private let firstNameTextInputView = CarfieTextInputView(title: "First Name", placeholder: "ex John", autocorrectionType: .no, validator: EmptyFieldValidator())
    private let lastNameTextInputView = CarfieTextInputView(title: "Last Name", placeholder: "ex Smith", autocorrectionType: .no, validator: EmptyFieldValidator())
    private let phoneNumberTextInputView = CarfieTextInputView(title: "Phone Number", placeholder: "ex 6518754689", keyboardType: .phonePad, validator: PhoneValidator())
    private let emailTextInputView = CarfieTextInputView(title: "Email", placeholder: "ex youremail@mail.com", keyboardType: .emailAddress, autocorrectionType: .no, validator: EmailValidator())
    private let confirmEmailTextInputView = CarfieTextInputView(title: "Confirm Email", placeholder: "ex youremail@mail.com", keyboardType: .emailAddress, autocorrectionType: .no)
    private let passwordTextInputView = CarfieTextInputView(title: "Password", placeholder: "ex Password1234", isSecureTextEntry: true, validator: PasswordValidator())
    private let confirmPasswordTextInputView = CarfieTextInputView(title: "Confirm Password", placeholder: "ex Password1234", isSecureTextEntry: true)
    
    // MARK: Inits
    
    init(theme: AppTheme) {
        self.theme = theme
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    private func setup() {
        backgroundColor = .white
        
        titleLabel.text = theme == .rider ? "SIGN UP TO RIDE" : "SIGN UP TO DRIVE"
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTouchUpInside(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside(_:)), for: .touchUpInside)
        
        [lastNameTextInputView, firstNameTextInputView, phoneNumberTextInputView, emailTextInputView, confirmEmailTextInputView, passwordTextInputView, confirmPasswordTextInputView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.errorMessageLabel.textColor = theme.tintColor
            $0.delegate = self
        }
        
        let nameFieldStackView = UIStackView(arrangedSubviews: [firstNameTextInputView, lastNameTextInputView])
        nameFieldStackView.distribution = .fillEqually
        nameFieldStackView.alignment = .firstBaseline
        nameFieldStackView.spacing = 14
        
        let emailFieldStackView = UIStackView(arrangedSubviews: [emailTextInputView, confirmEmailTextInputView])
        emailFieldStackView.axis = .vertical
        emailFieldStackView.spacing = 8
        
        let passwordFieldStackView = UIStackView(arrangedSubviews: [passwordTextInputView, confirmPasswordTextInputView])
        passwordFieldStackView.axis = .vertical
        passwordFieldStackView.spacing = 8
        
        let containerStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            nameFieldStackView,
            phoneNumberTextInputView,
            emailFieldStackView,
            passwordFieldStackView,
            signUpButton,
            cancelButton,
        ])
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = 24
        
        addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // We only need to restrict the first field in this stack view. The .fillEqually distribution will manage the other views.
            firstNameTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.5, constant: -nameFieldStackView.spacing / 2),
            
            phoneNumberTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            
            // We only need to restrict the width of the first field in each stack and the rest will fall in line.
            emailTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            passwordTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            
            signUpButton.widthAnchor.constraint(equalToConstant: 170),
            signUpButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: Selectors
    
    @objc private func signUpButtonTouchUpInside(_ sender: Any) {
        endEditing(true)
        
        let item = SignUpViewState(
            firstName: firstNameTextInputView.text,
            lastName: lastNameTextInputView.text,
            phone: phoneNumberTextInputView.text,
            email: emailTextInputView.text,
            confirmEmail: confirmEmailTextInputView.text,
            password: passwordTextInputView.text,
            confirmPassword: confirmPasswordTextInputView.text
        )
        
        delegate?.signUpRequested(with: item)
    }
    
    @objc private func cancelButtonTouchUpInside(_ sender: Any?) {
        delegate?.cancelSignUp()
    }
    
    // MARK: Presenters
    
    func present(_ emailInUseMessage: String) {
        emailTextInputView.errorMessageLabel.text = emailInUseMessage
    }
    
    func animateButton(_ shouldAnimate: Bool) {
        if shouldAnimate {
            signUpButton.startAnimating()
        } else {
            signUpButton.stopAnimating()
        }
    }
}

extension SignUpView: CarfieTextInputViewDelegate {
    func textInputViewDidBeginEditing(_ textInputView: CarfieTextInputView) {
        delegate?.textFieldDidBeginEditing(textInputView)
    }
    
    func textInputViewDidEndEditing(_ textInputView: CarfieTextInputView) {
        delegate?.textFieldDidEndEditing(textInputView)
    }
    
    func textInputViewShouldReturn(_ textInputView: CarfieTextInputView) -> Bool {
        let textInputView = textInputView
        
        switch textInputView {
        case firstNameTextInputView:
            lastNameTextInputView.makeTextFieldFirstResponser()
        case lastNameTextInputView:
            phoneNumberTextInputView.makeTextFieldFirstResponser()
        case phoneNumberTextInputView:
            emailTextInputView.makeTextFieldFirstResponser()
        case emailTextInputView:
            confirmEmailTextInputView.makeTextFieldFirstResponser()
        case confirmEmailTextInputView:
            passwordTextInputView.makeTextFieldFirstResponser()
        case passwordTextInputView:
            confirmPasswordTextInputView.makeTextFieldFirstResponser()
        case confirmPasswordTextInputView:
            confirmPasswordTextInputView.resignFirstResponder()
        default:
            textInputView.resignFirstResponder()
        }
        
        validateTextView(textInputView)
        
        return true
    }
    
    func validateAllFields() {
        [lastNameTextInputView, firstNameTextInputView, phoneNumberTextInputView, emailTextInputView, confirmEmailTextInputView, passwordTextInputView, confirmPasswordTextInputView].forEach {
            validateTextView($0)
        }
    }
    
    private func validateTextView(_ textInputView: CarfieTextInputView) {
        // Setup validators for views that need more complex validation.
        switch textInputView {
        case confirmEmailTextInputView:
            textInputView.validator = MatchingFieldValidator(fieldToMatch: emailTextInputView.text)
            delegate?.verifyEmailAvailability((email: emailTextInputView.text, confirmation: confirmEmailTextInputView.text))
        case confirmPasswordTextInputView:
            textInputView.validator = MatchingFieldValidator(fieldToMatch: passwordTextInputView.text)
        default:
            // All other input views already have a validator setup.
            break
        }
        // We don't care about the result here. This is just to provide immediate feedback to
        // the user about their input. Actual confirmation of validation will occur when the
        // "Sign Up" button is pressed.
        _ = textInputView.validate()
    }
}
