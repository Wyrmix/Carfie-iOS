//
//  OnboardingCarouselViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/21/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class WelcomeCarouselViewController: UIViewController, OnboardingScreen {
    static func viewController(theme: AppTheme) -> WelcomeCarouselViewController {
        let viewController = WelcomeCarouselViewController(theme: theme)
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    private let theme: AppTheme
    
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
        imageView.image = UIImage(named: "CarfieLogo")
        return imageView
    }()
    
    private let carouselView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let pageIndicator: UIView = {
        let indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .white
        return indicator
    }()
    
    private let signUpButton: CarfieButton
    private let signInButton: CarfieButton
        
    init(theme: AppTheme) {
        self.theme = theme
        self.signUpButton = CarfieButton(theme: theme)
        self.signInButton = CarfieButton(theme: theme)
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        addGradientLayer()
    }
    
    private func setupViews() {
        logoImageView.image = theme.logoImage
        signUpButton.setTitle("Sign Up", for: .normal)
        signInButton.setTitle("Sign In", for: .normal)
        
        let buttonStackView = UIStackView(arrangedSubviews: [signUpButton, signInButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        
        view.addSubview(logoImageView)
        view.addSubview(carfieLogoImageView)
        view.addSubview(carouselView)
        view.addSubview(pageIndicator)
        view.addSubview(buttonStackView)
        
        let carfieLogoHeightConstraint = carfieLogoImageView.heightAnchor.constraint(equalToConstant: 80)
        carfieLogoHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 124),
            
            carfieLogoImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            carfieLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            carfieLogoImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            carfieLogoHeightConstraint,
            
            carouselView.topAnchor.constraint(greaterThanOrEqualTo: carfieLogoImageView.bottomAnchor, constant: 16),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            carouselView.heightAnchor.constraint(equalToConstant: 386),
            
            pageIndicator.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 16),
            pageIndicator.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -16),
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageIndicator.widthAnchor.constraint(equalToConstant: 60),
            pageIndicator.heightAnchor.constraint(equalToConstant: 14),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 44),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = theme.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    @objc private func nextButtonTouchUpInside(_ sender: Any) {
        onboardingDelegate?.onboardingScreenComplete()
    }
}
