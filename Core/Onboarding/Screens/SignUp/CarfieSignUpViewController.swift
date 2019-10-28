//
//  SingUpViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class CarfieSignUpViewController: UIViewController, OnboardingScreen {
    static func viewController(theme: AppTheme) -> CarfieSignUpViewController {
        let viewController = CarfieSignUpViewController(theme: theme)
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    private let theme: AppTheme
    
    private var activeTextField: UITextField?
    
    // MARK: UI Components
    
    private let signUpScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 33
        return scrollView
    }()
    
    private let privacyPolicyButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .carfieBody
        label.text = "By signing up you agree to our privacy policy"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let signUpView: SignUpView

    // MARK: Inits
    
    init(theme: AppTheme) {
        self.theme = theme
        self.signUpView = SignUpView(theme: theme)
        
        super.init(nibName: nil, bundle: nil)
        
        signUpView.delegate = self
        
        view.backgroundColor = .white
        addObservers()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        addGradientLayer()
    }
    
    // MARK: View Setup
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViews() {
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signUpScrollView)
        signUpScrollView.addSubview(signUpView)
        view.addSubview(privacyPolicyButton)
        
        privacyPolicyButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            signUpScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            signUpScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            signUpScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            signUpView.topAnchor.constraint(equalTo: signUpScrollView.topAnchor),
            signUpView.leadingAnchor.constraint(equalTo: signUpScrollView.leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: signUpScrollView.trailingAnchor),
            signUpView.bottomAnchor.constraint(equalTo: signUpScrollView.bottomAnchor),
            signUpView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            
            privacyPolicyButton.topAnchor.constraint(equalTo: signUpScrollView.bottomAnchor, constant: 16),
            privacyPolicyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            privacyPolicyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = theme.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
}

// MARK: - SignUpViewDelegate and Keyboard Management
extension CarfieSignUpViewController: SignUpViewDelegate {
    func signUpButtonTouchUpInside() {
        // TODO: validation logic for sign up being complete
        onboardingDelegate?.onboardingScreenComplete()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardSize.cgRectValue
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        signUpScrollView.contentInset = contentInsets
        signUpScrollView.scrollIndicatorInsets = contentInsets
        
        guard let textField = activeTextField else { return }
        
        var visibleRect = self.view.frame
        visibleRect.size.height -= keyboardFrame.height
        if visibleRect.contains(textField.frame.origin) {
            signUpScrollView.scrollRectToVisible(textField.frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        signUpScrollView.contentInset = contentInsets
        signUpScrollView.scrollIndicatorInsets = contentInsets
    }
}
