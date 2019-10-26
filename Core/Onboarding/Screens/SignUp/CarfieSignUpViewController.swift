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
    
    // MARK: UI Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let carfieLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "carfieLogo")
        return imageView
    }()
    
    private let signUpScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setupViews() {
        logoImageView.image = theme.logoImage
        
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(carfieLogoImageView)
        view.addSubview(signUpScrollView)
        signUpScrollView.addSubview(signUpView)
        view.addSubview(privacyPolicyButton)
        
        privacyPolicyButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let carfieLogoHeightConstraint = carfieLogoImageView.heightAnchor.constraint(equalToConstant: 80)
        carfieLogoHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoImageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 124),
            
            carfieLogoImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            carfieLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            carfieLogoHeightConstraint,
            
            signUpScrollView.topAnchor.constraint(equalTo: carfieLogoImageView.bottomAnchor, constant: 16),
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

extension CarfieSignUpViewController: SignUpViewDelegate {
    func signUpButtonTouchUpInside() {
        // TODO: validation logic for sign up being complete
        onboardingDelegate?.onboardingScreenComplete()
    }
}

extension CarfieSignUpViewController: UIScrollViewDelegate {
    
}
