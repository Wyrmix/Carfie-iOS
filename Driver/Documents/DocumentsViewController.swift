//
//  DocumentsViewController.swift
//  Carfie
//
//  Created by Christopher.Olsen on 11/5/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController, OnboardingScreen {
    static func viewController() -> DocumentsViewController {
        let interactor = DocumentsInteractor()
        let viewController = DocumentsViewController(interactor: interactor)
        return viewController
    }
    
    weak var onboardingDelegate: OnboardingScreenDelegate?
    
    let interactor: DocumentsInteractor
    
    // MARK: UI Components
    
    private let documentViews: [DocumentView] = [
        DocumentView(),
        DocumentView(),
        DocumentView(),
        DocumentView(),
    ]
    
    private let directionsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.text = "Required Documents"
        label.font = .carfieHeroHeading
        return label
    }()
    
    private let directionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.text = "before you can start your Carfie driving adventure, we need a few documents."
        label.font = .carfieHeading
        return label
    }()
    
    private let uploadButton: CarfieButton = {
        let button = CarfieButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    // MARK: Inits
    
    init(interactor: DocumentsInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }
    
    // MARK: View Setup
    
    private func setupViews() {
        addGradientLayer()
        view.backgroundColor = .white
        
        let topDocumentStackView = UIStackView(arrangedSubviews: [documentViews[0], documentViews[1]])
        topDocumentStackView.distribution = .fillEqually
        topDocumentStackView.spacing = 48
        
        let bottomDocumentStackView = UIStackView(arrangedSubviews: [documentViews[2], documentViews[3]])
        bottomDocumentStackView.distribution = .fillEqually
        bottomDocumentStackView.spacing = 48
        
        let documentsStackView = UIStackView(arrangedSubviews: [topDocumentStackView, bottomDocumentStackView])
        documentsStackView.translatesAutoresizingMaskIntoConstraints = false
        documentsStackView.axis = .vertical
        documentsStackView.distribution = .fillEqually
        documentsStackView.spacing = 16
        
        view.addSubview(documentsStackView)
        view.addSubview(directionsTitleLabel)
        view.addSubview(directionsLabel)
        view.addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            documentsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            documentsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            directionsTitleLabel.topAnchor.constraint(equalTo: documentsStackView.bottomAnchor, constant: 16),
            directionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            directionsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            directionsLabel.topAnchor.constraint(equalTo: directionsTitleLabel.bottomAnchor, constant: 16),
            directionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            directionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            uploadButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 16),
            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            uploadButton.heightAnchor.constraint(equalToConstant: 44),
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = AppTheme.driver.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
}
