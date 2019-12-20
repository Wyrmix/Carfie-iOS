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
    private let profileController: ProfileController
    
    init(
        profileRepository: ProfileRepository = DefaultProfileRepository(),
        profileController: ProfileController = CarfieProfileController()
    ) {
        self.profileRepository = profileRepository
        self.profileController = profileController
        
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
    
    func selectProfilePhoto() {
        guard let presenter = viewController else { return }
        
        ImagePickerLauncherIntent(libraryCompletion: { _ in
            ImagePickerIntent(for: .photoLibrary)?.execute(via: presenter)
        }, cameraCompletion: { _ in
            ImagePickerIntent(for: .camera)?.execute(via: presenter)
        }).execute(via: presenter)
    }
    
    func setPhoto(_ image: UIImage?) {
        guard let image = image else { return }
        viewState.profilePhoto = image
    }
    
    func updateProfile(firstName: String?, lastName: String?) {
        do {
            viewState.profile?.firstName = try EmptyFieldValidator().validate(firstName).resolve()
            viewState.profile?.lastName = try EmptyFieldValidator().validate(lastName).resolve()

            guard let profile = viewState.profile else { return }
            
            viewState.updateProfileRequestInProgress = true
            
            if viewState.profilePhotoWasUpdated {
                uploadProfileWithPhoto(profile)
            } else {
                uploadProfileWithoutPhoto(profile)
            }
        } catch {
            return
        }
    }
    
    private func uploadProfileWithoutPhoto(_ profile: CarfieProfile) {
        profileController.updateProfile(profile) { [weak self] result in
            self?.viewState.updateProfileRequestInProgress = false

            do {
                self?.viewState.profile = try result.resolve()
                UserFacingErrorIntent(title: "Success", message: "Your profile has been updated.").execute(via: self?.viewController)
            } catch {
                UserFacingErrorIntent(title: "Something went wrong.", message: "Please try again.").execute(via: self?.viewController)
            }
        }
    }
    
    private func uploadProfileWithPhoto(_ profile: CarfieProfile) {
        guard let image = viewState.profilePhoto, viewState.profilePhotoWasUpdated else { return }
        guard let imageData = ImageResizer().resize(forUpload: image, withCompressionQualtiy: 0.5) else { return }
        
        let images = ["picture": imageData]
        let parameters = [
            "first_name": profile.firstName,
            "last_name": profile.lastName,
            "mobile": profile.mobile, // this is required in the request even though it can't be updated
        ]
        
        UploadProfilePictureService().uploadImages(images, parameters: parameters) { [weak self] result in
            self?.viewState.updateProfileRequestInProgress = false
            
            do {
                self?.viewState.profile = try result.resolve()
                UserFacingErrorIntent(title: "Success", message: "Your profile has been updated.").execute(via: self?.viewController)
            } catch {
                UserFacingErrorIntent(title: "Something went wrong.", message: "Please try again.").execute(via: self?.viewController)
            }
        }
    }
    
    func showChangePassword() {
        guard let profile = viewState.profile else { return }
        let changePasswordViewController = ChangePasswordViewController.viewController(for: .update, and: profile)
        viewController?.present(changePasswordViewController, animated: true)
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
