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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 33
        scrollView.layer.shadowRadius = 6
        scrollView.layer.shadowOffset = CGSize(width: 0, height: 3)
        scrollView.layer.shadowOpacity = 0.16
        scrollView.layer.shadowColor = UIColor.black.cgColor
        scrollView.layer.masksToBounds = true
        return scrollView
    }()
    
    private let socialSecurityNumberTextInputView = CarfieTextInputView(
        title: "Social Security Number",
        placeholder: "XXX-XX-XXXX",
        keyboardType: .numberPad,
        validator: SSNValidator()
    )
    
    let carInfoTitle: UILabel = {
        let label = UILabel()
        label.text = "TELL US ABOUT YOUR VEHICLE"
        label.textColor = .carfieDarkGray
        label.textAlignment = .center
        label.font = .carfieHeading
        label.numberOfLines = 0
        return label
    }()
    
    private let licensePlateTextInputView = CarfieTextInputView(
        title: "License Plate Number",
        validator: EmptyFieldValidator()
    )
    
    private let vehicleModelTextInputView = CarfieTextInputView(
        title: "Vehicle Model",
        validator: EmptyFieldValidator()
    )
    
    private let vehicleTypeTextInputView = CarfieTextInputView(
        title: "Ride Type",
        validator: EmptyFieldValidator()
    )
    
    private let vehicleTypePickerView = UIPickerView()
    
    private let directionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "We need to know a little more about you to connect you with Riders and ensure you get paid."
        label.textColor = .white
        label.textAlignment = .center
        label.font = .carfieHeading
        label.numberOfLines = 0
        return label
    }()
    
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
        setupPickerView()
        
        continueButton.addTarget(self, action: #selector(continueButtonTouchUpInside(_:)), for: .touchUpInside)
        
        view.addSubview(scrollView)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        let vehicleInfoStackView = UIStackView(arrangedSubviews: [carInfoTitle, licensePlateTextInputView, vehicleModelTextInputView, vehicleTypeTextInputView])
        vehicleInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        vehicleInfoStackView.axis = .vertical
        vehicleInfoStackView.spacing = 8
        containerView.addSubview(vehicleInfoStackView)
        
        let containerStackView = UIStackView(arrangedSubviews: [socialSecurityNumberTextInputView, vehicleInfoStackView])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = 32
        containerView.addSubview(containerStackView)
        
        view.addSubview(directionsLabel)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            
            directionsLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            directionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            directionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            continueButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 16),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 170),
            continueButton.heightAnchor.constraint(equalToConstant: 44),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = AppTheme.driver.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonPressed(_:)))
        toolbar.setItems([doneButton], animated: false)
        
        vehicleTypePickerView.dataSource = interactor
        vehicleTypePickerView.delegate = interactor
        vehicleTypeTextInputView.textField.inputView = vehicleTypePickerView
        vehicleTypeTextInputView.textField.inputAccessoryView = toolbar
    }
    
    // MARK: Presenters
    
    func animateNetworkActivity(_ shouldAnimate: Bool) {
        if shouldAnimate {
            continueButton.startAnimating()
        } else {
            continueButton.stopAnimating()
        }
    }
    
    func presentVehicleType(_ type: String) {
        vehicleTypeTextInputView.textField.text = type
    }
    
    // MARK: Selectors
    
    @objc private func continueButtonTouchUpInside(_ sender: Any?) {
        _ = socialSecurityNumberTextInputView.validate()
        _ = licensePlateTextInputView.validate()
        _ = vehicleModelTextInputView.validate()
        _ = vehicleTypeTextInputView.validate()
        
        interactor.saveDriverInformation(
            ssn: socialSecurityNumberTextInputView.text,
            model: vehicleModelTextInputView.text,
            number: licensePlateTextInputView.text
        )
    }
    
    @objc private func pickerDoneButtonPressed(_ sender: Any?) {
        view.endEditing(true)
    }
}

// MARK: - SignUpInteractorDelegate
extension DriverIdentificationViewController {
    func adjustScrollViewForKeyboard(_ scrollViewPosition: ScrollViewPosition, and viewToScroll: UIView?) {
        scrollView.contentInset = scrollViewPosition.insets
        scrollView.scrollIndicatorInsets = scrollViewPosition.insets
        
        guard let viewToScroll = viewToScroll else { return }
        
        var visibleRect = self.view.frame
        visibleRect.size.height -= scrollViewPosition.frame.height
        if visibleRect.contains(viewToScroll.frame.origin) {
            scrollView.scrollRectToVisible(viewToScroll.frame, animated: true)
        }
    }
}
