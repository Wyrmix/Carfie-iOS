//
//  LoginViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    static func viewController(for theme: AppTheme) -> LoginViewController {
        let interactor = LoginInteractor(theme: theme)
        let viewController = LoginViewController(theme: theme, interactor: interactor)
        interactor.viewController = viewController
        return viewController
    }
    
    private let theme: AppTheme
    
    let interactor: LoginInteractor
    
    // MARK: UI Components
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 33
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .carfieHeading
        label.textColor = .carfieDarkGray
        return label
    }()
    
    private let emailTextInputView = CarfieTextInputView(title: "Email", keyboardType: .emailAddress, autocorrectionType: .no)
    private let passwordTextInputView = CarfieTextInputView(title: "Password", isSecureTextEntry: true, autocorrectionType: .no)
    
    private let signInButton: AnimatedCarfieButton = {
        let button = AnimatedCarfieButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        return button
    }()
    
    private let cancelButton: CarfieSecondaryButton = {
        let button = CarfieSecondaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    private let forgotPasswordButton: CarfieSecondaryButton = {
        let button = CarfieSecondaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot password", for: .normal)
        return button
    }()
    
    // MARK: Inits
    
    init(theme: AppTheme, interactor: LoginInteractor) {
        self.theme = theme
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: View Setup
    
    private func setupViews() {
        view.backgroundColor = .white
        addGradientLayer()
        
        titleLabel.text = theme == .rider ? "SIGN IN TO RIDE" : "SIGN IN TO DRIVE"
        
        signInButton.addTarget(self, action: #selector(signInButtonTouchUpInside(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside(_:)), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTouchUpInside(_:)), for: .touchUpInside)
        
        [emailTextInputView, passwordTextInputView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.errorMessageLabel.tintColor = theme.tintColor
        }
        
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(emailTextInputView)
        backgroundView.addSubview(passwordTextInputView)
        backgroundView.addSubview(signInButton)
        backgroundView.addSubview(cancelButton)
        backgroundView.addSubview(forgotPasswordButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            emailTextInputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            emailTextInputView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            emailTextInputView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            passwordTextInputView.topAnchor.constraint(equalTo: emailTextInputView.bottomAnchor, constant: 8),
            passwordTextInputView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            passwordTextInputView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextInputView.bottomAnchor, constant: 16),
            signInButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 170),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 8),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            forgotPasswordButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),
        ])
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = theme.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func animateNetworkActivity(_ shouldAnimate: Bool) {
        if shouldAnimate {
            signInButton.startAnimating()
        } else {
            signInButton.stopAnimating()
        }
    }
    
    // MARK: Selectors
    
    @objc private func signInButtonTouchUpInside(_ sender: Any?) {
        interactor.login(email: emailTextInputView.text, password: passwordTextInputView.text)
    }
    
    @objc private func cancelButtonTouchUpInside(_ sender: Any?) {
        interactor.cancelLogin()
    }
    
    @objc private func forgotPasswordButtonTouchUpInside(_ sender: CarfieSecondaryButton?) {
        interactor.showForgotPassword()
    }
}
