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
        let interactor = SignUpInteractor()
        let viewController = CarfieSignUpViewController(theme: theme, interactor: interactor)
        interactor.viewController = viewController
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    private let theme: AppTheme
    
    private let interactor: SignUpInteractor
    
    // MARK: UI Components
    
    private let signUpScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 33
        return scrollView
    }()
    
    // TODO: fix truncation on iPhone SE
    private let privacyPolicyButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .carfieBody
        label.text = "By signing up you agree to our privacy policy"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let signUpView: SignUpView

    // MARK: Inits
    
    init(theme: AppTheme, interactor: SignUpInteractor) {
        self.theme = theme
        self.interactor = interactor
        self.signUpView = SignUpView(theme: theme)
        
        super.init(nibName: nil, bundle: nil)
        
        setupPresenters()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupPresenters() {
        signUpView.delegate = interactor
        interactor.signUpViewPresenter = SignUpViewPresenter(signUpView: signUpView)
    }
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        addGradientLayer()
    }
    
    // MARK: View Setup
    
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
            signUpView.widthAnchor.constraint(equalTo: signUpScrollView.widthAnchor),
            
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

// MARK: - SignUpInteractorDelegate
extension CarfieSignUpViewController: SignUpInteractorDelegate {
    func adjustScrollViewForKeyboard(_ scrollViewPosition: ScrollViewPosition, and viewToScroll: UIView?) {
        signUpScrollView.contentInset = scrollViewPosition.insets
        signUpScrollView.scrollIndicatorInsets = scrollViewPosition.insets
        
        guard let viewToScroll = viewToScroll else { return }
        
        var visibleRect = self.view.frame
        visibleRect.size.height -= scrollViewPosition.frame.height
        if visibleRect.contains(viewToScroll.frame.origin) {
            signUpScrollView.scrollRectToVisible(viewToScroll.frame, animated: true)
        }
    }
}
