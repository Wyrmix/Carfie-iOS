//
//  SignUpView.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol SignUpViewDelegate: class {
    func signUpButtonTouchUpInside()
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
}

class SignUpView: UIView {
    
    weak var delegate: SignUpViewDelegate?
    
    private let theme: AppTheme
    
    // MARK: UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SIGN UP TO RIDE"
        label.font = .carfieHeading
        label.textColor = .carfieDarkGray
        return label
    }()
    
    private let signUpButton: CarfieButton
    
    // MARK: Input Fields
    
    private let firstNameTextInputView = CarfieTextInputView(title: "First Name", placeholder: "ex John")
    private let lastNameTextInputView = CarfieTextInputView(title: "Last Name", placeholder: "ex Smith")
    private let emailTextInputView = CarfieTextInputView(title: "Email", placeholder: "ex youremail@mail.com", keyboardType: .emailAddress)
    private let confirmEmailTextInputView = CarfieTextInputView(title: "Confirm Email", placeholder: "ex youremail@mail.com", keyboardType: .emailAddress)
    private let passwordTextInputView = CarfieTextInputView(title: "Password", placeholder: "ex Password1234", isSecureTextEntry: true)
    private let confirmPasswordTextInputView = CarfieTextInputView(title: "Confirm Password", placeholder: "ex Password1234", isSecureTextEntry: true)
    
    // MARK: Inits
    
    init(theme: AppTheme) {
        self.theme = theme
        self.signUpButton = CarfieButton(theme: theme)
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    private func setup() {
        backgroundColor = .white
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpButtonTouchUpInside(_:)), for: .touchUpInside)
        
        [lastNameTextInputView, firstNameTextInputView, emailTextInputView, confirmEmailTextInputView, passwordTextInputView, confirmPasswordTextInputView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textField.delegate = self
        }
        
        let nameFieldStackView = UIStackView(arrangedSubviews: [firstNameTextInputView, lastNameTextInputView])
        nameFieldStackView.distribution = .fillEqually
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
            emailFieldStackView,
            passwordFieldStackView,
            signUpButton,
        ])
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.distribution = .fillProportionally
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
            
            // We only need to restrict the width of the first field in each stack and the rest will fall in line.
            emailTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            passwordTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            
            signUpButton.widthAnchor.constraint(equalToConstant: 170),
            signUpButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: Selectors
    
    @objc private func signUpButtonTouchUpInside(_ sender: Any) {
        delegate?.signUpButtonTouchUpInside()
    }
}

// MARK: - UITextFieldDelegate
extension SignUpView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextInputView.textField:
            lastNameTextInputView.makeTextFieldFirstResponser()
        case lastNameTextInputView.textField:
            emailTextInputView.makeTextFieldFirstResponser()
        case emailTextInputView.textField:
            confirmEmailTextInputView.makeTextFieldFirstResponser()
        case confirmEmailTextInputView.textField:
            passwordTextInputView.makeTextFieldFirstResponser()
        case passwordTextInputView.textField:
            confirmPasswordTextInputView.makeTextFieldFirstResponser()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}
