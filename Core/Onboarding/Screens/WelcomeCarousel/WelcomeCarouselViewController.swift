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
    static func viewController(theme: AppTheme) -> WelcomeCarouselViewController {
        let interactor = WelcomeCarouselInteractor(theme: theme)
        let viewController = WelcomeCarouselViewController(theme: theme, interactor: interactor)
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    private var interactor: WelcomeCarouselInteractor
    
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
    
    private let pageIndicator: UIPageControl = {
        let indicator = UIPageControl()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isUserInteractionEnabled = false
        indicator.currentPageIndicatorTintColor = .white
        indicator.backgroundColor = .clear
        indicator.currentPage = 0
        return indicator
    }()
    
    private let signUpButton = CarfieButton()
    private let signInButton = CarfieButton()
    
    // MARK: Collection View Properties
    
    private var carouselItems: [WelcomeCarouselCellViewState] = []
    
    // MARK: Lifecycle
    
    init(theme: AppTheme, interactor: WelcomeCarouselInteractor) {
        self.theme = theme
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        self.interactor.viewController = self
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        interactor.getCarouselItemsData()
        addGradientLayer()
    }
    
    // MARK: View Setup
    
    private func setupViews() {
        carouselView.register(WelcomeCarouselTextCell.self, forCellWithReuseIdentifier: WelcomeCarouselTextCell.reuseIdentifier)
        carouselView.register(WelcomeCarouselImageCell.self, forCellWithReuseIdentifier: WelcomeCarouselImageCell.reuseIdentifier)
        carouselView.delegate = self
        carouselView.dataSource = self
        
        logoImageView.image = theme.logoImage
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTouchUpInside(_:)), for: .touchUpInside)
        
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTouchUpInside(_:)), for: .touchUpInside)
        
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
            logoImageView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoImageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 124),
            
            carfieLogoImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            carfieLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            carfieLogoHeightConstraint,
            
            carouselView.topAnchor.constraint(greaterThanOrEqualTo: carfieLogoImageView.bottomAnchor, constant: 16),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 416),
            
            pageIndicator.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 4),
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // This is a, hopefully, temporary hack to make things look ok on an iPhone SE.
        if carfieLogoImageView.bounds.height < 24 {
            carfieLogoImageView.isHidden = true
        }
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = theme.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: Selectors
    
    @objc private func signInButtonTouchUpInside(_ sender: Any) {
        onboardingDelegate?.launchLogin()
    }
    
    @objc private func signUpButtonTouchUpInside(_ sender: Any) {
        onboardingDelegate?.onboardingScreenComplete()
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension WelcomeCarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func presentCarouselItems(_ carouselItems: [WelcomeCarouselCellViewState]) {
        self.carouselItems = carouselItems
        pageIndicator.numberOfPages = carouselItems.count
        carouselView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: (UICollectionViewCell & WelcomeCell)?
        
        switch carouselItems[indexPath.row].cellType {
        case .text:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeCarouselTextCell.reuseIdentifier, for: indexPath) as? WelcomeCarouselTextCell & WelcomeCell
        case .image:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeCarouselImageCell.reuseIdentifier, for: indexPath) as? WelcomeCarouselImageCell & WelcomeCell
        }
        
        guard let welcomeCell = cell else {
            fatalError("Could not dequeue UICollectionViewCell of type WelcomeCell")
        }
        
        welcomeCell.configure(with: carouselItems[indexPath.row])
        welcomeCell.delegate = interactor
        
        return welcomeCell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in carouselView.visibleCells {
            guard let index = carouselView.indexPath(for: cell)?.row else { return }
            pageIndicator.currentPage = index
            
            guard let welcomeCell = cell as? WelcomeCell else { continue }
            welcomeCell.playAnimation()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
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
