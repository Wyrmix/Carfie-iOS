//
//  ChangePasswordViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    static func viewController(for changeType: ChangePasswordType, and profile: CarfieProfile) -> ChangePasswordViewController {
        let coordinator = ChangePasswordCoordinator(changeType: changeType, profile: profile)
        let viewController = ChangePasswordViewController(coordinator: coordinator)
        coordinator.viewController = viewController
        coordinator.start()
        return viewController
    }
    
    let coordinator: ChangePasswordCoordinator
    
    // MARK: UI Components
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let oldPasswordTextInputView = CarfieTextInputView(
        title: "Old Password",
        isSecureTextEntry: true,
        autocorrectionType: .no,
        validator: EmptyFieldValidator()
    )
    
    private let newPasswordTextInputView = CarfieTextInputView(
        title: "New Password",
        isSecureTextEntry: true,
        autocorrectionType: .no,
        validator: PasswordValidator()
    )
    
    private let confirmNewPasswordTextInputView = CarfieTextInputView(
        title: "Confirm New Password",
        isSecureTextEntry: true,
        autocorrectionType: .no
    )
    
    private let updatePasswordButon: AnimatedCarfieButton = {
        let button = AnimatedCarfieButton()
        button.addTarget(self, action: #selector(updateButtonTouchUpInside(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update Password", for: .normal)
        return button
    }()
    
    // MARK: Inits
    
    init(coordinator: ChangePasswordCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
        setupPresenter()
        setupViews()
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
    
    // MARK: Setup
    
    private func setupPresenter() {
        coordinator.presenter = ChangePasswordPresenter(oldPasswordInputView: oldPasswordTextInputView, updatePasswordButton: updatePasswordButon)
    }
    
    private func setupViews() {
        title = "Change Password"
        view.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        [oldPasswordTextInputView, newPasswordTextInputView, confirmNewPasswordTextInputView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = coordinator
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(oldPasswordTextInputView)
        containerView.addSubview(newPasswordTextInputView)
        containerView.addSubview(confirmNewPasswordTextInputView)
        containerView.addSubview(updatePasswordButon)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            oldPasswordTextInputView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            oldPasswordTextInputView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            oldPasswordTextInputView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            newPasswordTextInputView.topAnchor.constraint(equalTo: oldPasswordTextInputView.bottomAnchor, constant: 8),
            newPasswordTextInputView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            newPasswordTextInputView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            confirmNewPasswordTextInputView.topAnchor.constraint(equalTo: newPasswordTextInputView.bottomAnchor, constant: 8),
            confirmNewPasswordTextInputView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            confirmNewPasswordTextInputView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            updatePasswordButon.topAnchor.constraint(equalTo: confirmNewPasswordTextInputView.bottomAnchor, constant: 16),
            updatePasswordButon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            updatePasswordButon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            updatePasswordButon.heightAnchor.constraint(equalToConstant: 44),
            updatePasswordButon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: Selectors
    
    @objc private func updateButtonTouchUpInside(_ sender: CarfieButton?) {
        coordinator.updatePassword(
            old: oldPasswordTextInputView.text,
            new: newPasswordTextInputView.text,
            confirm: confirmNewPasswordTextInputView.text
        )
    }
}
// MARK: - Keyboard Management
extension ChangePasswordViewController {
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
