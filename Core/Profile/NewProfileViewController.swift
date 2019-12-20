//
//  ProfileViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class NewProfileViewController: UIViewController {
    static func viewController() -> NewProfileViewController {
        let coordinator = ProfileCoordinator()
        let viewController = NewProfileViewController(coordinator: coordinator)
        coordinator.viewController = viewController
        coordinator.start()
        return viewController
    }
    
    private let coordinator: ProfileCoordinator
    
    // MARK: UI Components
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "EmptyUserImage")
        return imageView
    }()
    
    private let firstNameTextInputView = CarfieTextInputView(title: "First Name", placeholder: "ex John", autocorrectionType: .no, validator: EmptyFieldValidator())
    private let lastNameTextInputView = CarfieTextInputView(title: "Last Name", placeholder: "ex Smith", autocorrectionType: .no, validator: EmptyFieldValidator())
    private let phoneNumberTextInputView = CarfieTextInputView(title: "Phone Number", placeholder: "ex 6518754689")
    private let emailTextInputView = CarfieTextInputView(title: "Email", placeholder: "ex youremail@mail.com")
    
    private let saveButton: AnimatedCarfieButton = {
        let button = AnimatedCarfieButton()
        button.addTarget(self, action: #selector(saveButtonTouchUpInside(_:)), for: .touchUpInside)
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    private let updatePasswordButton: CarfieSecondaryButton = {
        let button = CarfieSecondaryButton()
        button.addTarget(self, action: #selector(updatePasswordButtonTouchUpInside(_:)), for: .touchUpInside)
        button.setTitle("Change your password", for: .normal)
        return button
    }()
    
    // MARK: Inits
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
        setupViews()
        setupPresenter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: iOS Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.maskToBounds = true
    }
    
    // MARK: Setup
    
    private func setupPresenter() {
        coordinator.presenter = ProfilePresenter(
            profileImageView: profileImageView,
            firstNameTextInputView: firstNameTextInputView,
            lastNameTextInputView: lastNameTextInputView,
            phoneNumberTextInputView: phoneNumberTextInputView,
            emailTextInputView: emailTextInputView,
            saveButton: saveButton
        )
    }
    
    private func setupViews() {
        title = "Profile"
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewDidTapInside(_:)))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        [firstNameTextInputView, lastNameTextInputView].forEach {
            $0.delegate = coordinator
        }
        
        // User cannot change these values in app.
        phoneNumberTextInputView.textField.isUserInteractionEnabled = false
        emailTextInputView.textField.isUserInteractionEnabled = false
        
        view.addSubview(scrollView)
        
        let nameFieldStackView = UIStackView(arrangedSubviews: [firstNameTextInputView, lastNameTextInputView])
        nameFieldStackView.distribution = .fillEqually
        nameFieldStackView.alignment = .firstBaseline
        nameFieldStackView.spacing = 14
        
        let containerStackView = UIStackView(arrangedSubviews: [
//            profileImageView,
            nameFieldStackView,
            phoneNumberTextInputView,
            emailTextInputView,
            saveButton,
            updatePasswordButton,
        ])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = 16
        
        scrollView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            containerStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 24),
            
            // We only need to restrict the first field in this stack view. The .fillEqually distribution will manage the other views.
            firstNameTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.5, constant: -nameFieldStackView.spacing / 2),
            
            phoneNumberTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            emailTextInputView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            
//            profileImageView.widthAnchor.constraint(equalToConstant: 120),
//            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            saveButton.widthAnchor.constraint(equalToConstant: 170),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            updatePasswordButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: Selectors
    
    @objc private func profileImageViewDidTapInside(_ sender: UIImageView?) {
        coordinator.selectProfilePhoto()
    }
    
    @objc private func saveButtonTouchUpInside(_ sender: AnimatedCarfieButton?) {
        _ = firstNameTextInputView.validate()
        _ = lastNameTextInputView.validate()
        
        coordinator.updateProfile(
            firstName: firstNameTextInputView.text,
            lastName: lastNameTextInputView.text
        )
    }
    
    @objc private func updatePasswordButtonTouchUpInside(_ sender: CarfieSecondaryButton?) {
        coordinator.showChangePassword()
    }
}

// MARK: - ScrollableView
extension NewProfileViewController: ScrollableView {
    var containingView: UIView {
        return view
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension NewProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [ weak self] in
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                self?.coordinator.setPhoto(nil)
                return
            }
            
            self?.coordinator.setPhoto(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.coordinator.setPhoto(nil)
        }
    }
}
