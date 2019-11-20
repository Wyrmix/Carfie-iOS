//
//  DriverIdentificationViewController.swift
//  Driver
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DriverIdentificationViewController: UIViewController, OnboardingScreen {
    static func viewController() -> DriverIdentificationViewController {
        let interactor = DriverIdentificationInteractor()
        let viewController = DriverIdentificationViewController(interactor: interactor)
        interactor.viewController = viewController
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    private let interactor: DriverIdentificationInteractor
    
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
        label.text = "We need your social security number before you start driving"
        label.textAlignment = .center
        label.font = .carfieSmallBody
        label.textColor = .carfieDarkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let socialSecurityNumberTextInputView = CarfieTextInputView(
        title: "Social Security Number",
        placeholder: "XXX-XX-XXXX",
        keyboardType: .numberPad,
        validator: SSNValidator()
    )
    
    private let continueButton: AnimatedCarfieButton = {
        let button  = AnimatedCarfieButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    // MARK: Inits
    
    init(interactor: DriverIdentificationInteractor) {
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
        
        continueButton.addTarget(self, action: #selector(continueButtonTouchUpInside(_:)), for: .touchUpInside)
        
        socialSecurityNumberTextInputView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(socialSecurityNumberTextInputView)
        backgroundView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            socialSecurityNumberTextInputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            socialSecurityNumberTextInputView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            socialSecurityNumberTextInputView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            continueButton.topAnchor.constraint(equalTo: socialSecurityNumberTextInputView.bottomAnchor, constant: 16),
            continueButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 170),
            continueButton.heightAnchor.constraint(equalToConstant: 44),
            continueButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),
        ])
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = AppTheme.driver.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: Presenters
    
    func animateNetworkActivity(_ shouldAnimate: Bool) {
        if shouldAnimate {
            continueButton.startAnimating()
        } else {
            continueButton.stopAnimating()
        }
    }
    
    // MARK: Selectors
    
    @objc private func continueButtonTouchUpInside(_ selector: Any?) {
        _ = socialSecurityNumberTextInputView.validate()
        interactor.saveSocialSecurityNumber(socialSecurityNumberTextInputView.text)
    }
}
