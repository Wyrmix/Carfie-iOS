//
//  OnboardingCarouselViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/21/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// The first view controller the User sees when launching the app.
/// Contains links for sign-in and sign-up as well as a carousel of promotions and other info for the user.
class WelcomeCarouselViewController: UIViewController, OnboardingScreen {
    static func viewController(theme: AppTheme, interactor: WelcomeCarouselInteractor) -> WelcomeCarouselViewController {
        let viewController = WelcomeCarouselViewController(theme: theme, interactor: interactor)
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    private var interactor: WelcomeCarouselInteractor
    
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
    
    private let carouselView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
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
    
    private let reuseIdentifier = "WelcomePromoCell"
    
    private var carouselItems: [WelcomeCarouselCellViewState] = []
        
    init(theme: AppTheme, interactor: WelcomeCarouselInteractor) {
        self.theme = theme
        self.interactor = interactor
        self.signUpButton = CarfieButton(theme: theme)
        self.signInButton = CarfieButton(theme: theme)
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        self.interactor.viewController = self
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        interactor.getCarouselItemsData()
        addGradientLayer()
    }
    
    private func setupViews() {
        carouselView.register(WelcomeCarouselCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        carouselView.delegate = self
        carouselView.dataSource = self
        
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

// MARK: - UICollectionViewDelegate & DataSource
extension WelcomeCarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func presentCarouselItems(_ carouselItems: [WelcomeCarouselCellViewState]) {
        self.carouselItems = carouselItems
        carouselView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? WelcomeCarouselCollectionViewCell else {
            fatalError("Could not dequeue UICollectionViewCell of type WelcomeCarouselCollectionViewCell")
        }
        
        cell.configure(with: carouselItems[indexPath.row])
        return cell
    }
}

extension WelcomeCarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}