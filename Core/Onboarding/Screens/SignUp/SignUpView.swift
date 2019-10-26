//
//  SignUpView.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol SignUpViewDelegate: class {
    func signUpButtonTouchUpInside()
}

class SignUpView: UIView {
    
    weak var delegate: SignUpViewDelegate?
    
    private let theme: AppTheme
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SIGN UP TO RIDE"
        label.font = .carfieHeading
        label.textColor = .carfieDarkGray
        return label
    }()
    
    private let signUpButton: CarfieButton
    
    init(theme: AppTheme) {
        self.theme = theme
        self.signUpButton = CarfieButton(theme: theme)
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setup() {
        backgroundColor = .white
        
        layer.cornerRadius = 33
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpButtonTouchUpInside(_:)), for: .touchUpInside)
        
        let containerStackView = UIStackView(arrangedSubviews: [titleLabel, signUpButton])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.distribution = .fillProportionally
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = 24
        
        addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            signUpButton.widthAnchor.constraint(equalToConstant: 170),
            signUpButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc private func signUpButtonTouchUpInside(_ sender: Any) {
        delegate?.signUpButtonTouchUpInside()
    }
}
