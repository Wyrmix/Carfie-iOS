//
//  LocationPermissionsViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Lottie
import UIKit

class LocationPermissionsViewController: UIViewController, OnboardingScreen {
    static func viewController(theme: AppTheme) -> LocationPermissionsViewController {
        let interactor = LocationPermissionsInteractor()
        let viewController = LocationPermissionsViewController(theme: theme, interactor: interactor)
        interactor.viewController = viewController
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    private let theme: AppTheme
    
    private let interactor: LocationPermissionsInteractor
    
    private var subtitleThemedText: String {
        switch theme {
        case .driver:
            return "riders"
        case .rider:
            return "drivers"
        }
    }
    
    // MARK: UI Components
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "location-permissions")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    private let boldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .carfieHeroHeading
        label.text = "First things first"
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .carfieHeading
        label.numberOfLines = 0
        return label
    }()
    
    private let soundsGoodButton: CarfieButton
    
    // MARK: Inits
    
    init(theme: AppTheme, interactor: LocationPermissionsInteractor) {
        self.theme = theme
        self.interactor = interactor
        self.soundsGoodButton = CarfieButton(theme: theme)
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addGradientLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    // MARK: View Setup
    
    private func setupViews() {
        soundsGoodButton.setTitle("Sounds good to me", for: .normal)
        soundsGoodButton.translatesAutoresizingMaskIntoConstraints = false
        soundsGoodButton.addTarget(self, action: #selector(soundsGoodButtonTouchUpInside(_:)), for: .touchUpInside)
        
        subtitleLabel.text = "Carfie needs location and notification permissions to help connect you with nearby \(subtitleThemedText)"
        
        view.addSubview(animationView)
        view.addSubview(boldLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(soundsGoodButton)
        
        let container = UILayoutGuide()
        view.addLayoutGuide(container)
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            animationView.topAnchor.constraint(equalTo: container.topAnchor),
            animationView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 240),
            animationView.widthAnchor.constraint(equalToConstant: 240),
            
            boldLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 64),
            boldLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            boldLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: boldLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            soundsGoodButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            soundsGoodButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            soundsGoodButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            soundsGoodButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            soundsGoodButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = theme.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: Selectors
    
    @objc private func soundsGoodButtonTouchUpInside(_ sender: Any) {
        interactor.requestLocationPermissions()
    }
}
