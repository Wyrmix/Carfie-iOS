//
//  ProfileCoordinator.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class ProfileCoordinator {
    
    weak var viewController: NewProfileViewController?
    
    var viewState: ProfileCoordinatorViewState {
        didSet {
            presenter?.present(viewState)
        }
    }
    
    var presenter: ProfilePresenter?
    
    private var activeTextInputView: CarfieTextInputView?
    
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository = DefaultProfileRepository()) {
        self.profileRepository = profileRepository
        self.viewState = ProfileCoordinatorViewState(profile: profileRepository.profile)
    }
    
    func start() {
        presenter?.present(viewState)
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - CarfieTextInputViewDelegate
extension ProfileCoordinator: CarfieTextInputViewDelegate {
    func textInputViewDidBeginEditing(_ textInputView: CarfieTextInputView) {
        activeTextInputView = textInputView
    }
    
    func textInputViewDidEndEditing(_ textInputView: CarfieTextInputView) {
        _ = textInputView.validate()
        activeTextInputView = nil
    }
    
    func textInputViewShouldReturn(_ textInputView: CarfieTextInputView) -> Bool {
        _ = textInputView.validate()
        textInputView.resignTextFieldFirstResponder()
        return true
    }
}

// MARK: - Keyboard Management
extension ProfileCoordinator {
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardFrame = keyboardSize.cgRectValue
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        viewController?.adjustScrollViewForKeyboard((insets: contentInsets, frame: keyboardFrame), and: activeTextInputView)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        viewController?.adjustScrollViewForKeyboard((insets: .zero, frame: .zero), and: nil)
    }
}
