//
//  SingUpViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class CarfieSignUpViewController: UIViewController, OnboardingScreen {
    static func viewController() -> CarfieSignUpViewController {
        let viewController = CarfieSignUpViewController()
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        title = "Sign Up"
        
        setupViews()
    }
    
    private func setupViews() {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.carfieBlue, for: .normal)
        button.addTarget(self, action: #selector(nextButtonTouchUpInside(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 160),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    @objc private func nextButtonTouchUpInside(_ sender: Any) {
        onboardingDelegate?.onboardingScreenComplete()
    }
}
