//
//  ChangePasswordPresenter.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class ChangePasswordPresenter {
    private let oldPasswordInputView: CarfieTextInputView
    private let updatePasswordButton: AnimatedCarfieButton
    
    init(oldPasswordInputView: CarfieTextInputView, updatePasswordButton: AnimatedCarfieButton) {
        self.oldPasswordInputView = oldPasswordInputView
        self.updatePasswordButton = updatePasswordButton
    }
    
    func present(_ viewState: ChangePasswordViewState) {
        oldPasswordInputView.title = viewState.oldPasswordInputViewTitle
        
        if viewState.updatePasswordRequestInProgress {
            updatePasswordButton.startAnimating()
        } else {
            updatePasswordButton.stopAnimating()
        }
    }
}
