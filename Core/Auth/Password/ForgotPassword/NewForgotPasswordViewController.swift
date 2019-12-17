//
//  ForgotPasswordViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class NewForgotPasswordViewController: UIViewController {
    static func viewController() -> NewForgotPasswordViewController {
        let coordinator = ForgotPasswordCoordinator()
        let viewController = NewForgotPasswordViewController(coordinator: coordinator)
        coordinator.viewController = viewController
        coordinator.start()
        return viewController
    }
    
    private let coordinator: ForgotPasswordCoordinator
    
    // MARK: UI Components
    
    private let emailTextInputView = CarfieTextInputView(
        title: "Enter your email",
        keyboardType: .emailAddress,
        autocorrectionType: .no,
        validator: EmailValidator()
    )
    
    private let continueButton: AnimatedCarfieButton = {
        let button = AnimatedCarfieButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueButtonTouchUpInside(_:)), for: .touchUpInside)
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    // MARK: Inits
    
    init(coordinator: ForgotPasswordCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
        setupViews()
        setupPresenter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: iOS Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    // MARK: Setup
    
    private func setupPresenter() {
        coordinator.presenter = ForgotPasswordPresenter(continueButton: continueButton)
    }
    
    private func setupViews() {
        title = "Forgot Password"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouchUpInside(_:)))
        
        emailTextInputView.translatesAutoresizingMaskIntoConstraints = false
        emailTextInputView.textField.returnKeyType = .done

        view.addSubview(emailTextInputView)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            emailTextInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            emailTextInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            continueButton.topAnchor.constraint(lessThanOrEqualTo: emailTextInputView.bottomAnchor, constant: 16),
            continueButton.heightAnchor.constraint(equalToConstant: 44),
            continueButton.widthAnchor.constraint(equalToConstant: 170),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: Selectors
    
    @objc private func cancelButtonTouchUpInside(_ sender: UIBarButtonItem?) {
        dismiss(animated: true)
    }
    
    @objc private func continueButtonTouchUpInside(_ sender: CarfieButton?) {
        _ = emailTextInputView.validate()
        coordinator.checkEmail(emailTextInputView.text)
    }
}
