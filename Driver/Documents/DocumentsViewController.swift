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
        interactor.viewController = viewController
        interactor.start()
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
        
        documentViews.forEach {
            $0.delegate = interactor
        }
        
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
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(documentsStackView)
        scrollView.addSubview(directionsTitleLabel)
        scrollView.addSubview(directionsLabel)
        scrollView.addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            documentsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            documentsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            documentsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            documentsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            
            directionsTitleLabel.topAnchor.constraint(equalTo: documentsStackView.bottomAnchor, constant: 16),
            directionsTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            directionsTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            directionsLabel.topAnchor.constraint(equalTo: directionsTitleLabel.bottomAnchor, constant: 16),
            directionsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            directionsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            uploadButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 16),
            uploadButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            uploadButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            uploadButton.heightAnchor.constraint(equalToConstant: 44),
            uploadButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        ])
    }
    
    private func addGradientLayer() {
        let gradient  = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = AppTheme.driver.onboardingGradientColors
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: Presentation
    
    func presentDocuments(from viewModel: DocumentsViewModel) {
        for (index, item) in viewModel.documentItems.enumerated() {
            documentViews[index].configure(with: item)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [ weak self] in
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                self?.interactor.updateDocumentWithImage(nil)
                return
            }
            
            self?.interactor.updateDocumentWithImage(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.interactor.updateDocumentWithImage(nil)
        }
    }
}
