//
//  ProfilePresenter.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class ProfilePresenter {
    var firstNameTextInputView: CarfieTextInputView
    var lastNameTextInputView: CarfieTextInputView
    var phoneNumberTextInputView: CarfieTextInputView
    var emailTextInputView: CarfieTextInputView
    var saveButton: AnimatedCarfieButton
    
    init(
        firstNameTextInputView: CarfieTextInputView,
        lastNameTextInputView: CarfieTextInputView,
        phoneNumberTextInputView: CarfieTextInputView,
        emailTextInputView: CarfieTextInputView,
        saveButton: AnimatedCarfieButton
    ) {
        self.firstNameTextInputView = firstNameTextInputView
        self.lastNameTextInputView = lastNameTextInputView
        self.phoneNumberTextInputView = phoneNumberTextInputView
        self.emailTextInputView = emailTextInputView
        self.saveButton = saveButton
    }
    
    func present(_ viewState: ProfileCoordinatorViewState) {
        firstNameTextInputView.textField.text = viewState.profile?.firstName
        lastNameTextInputView.textField.text = viewState.profile?.lastName
        phoneNumberTextInputView.textField.text = viewState.profile?.mobile
        emailTextInputView.textField.text = viewState.profile?.email
    }
}
