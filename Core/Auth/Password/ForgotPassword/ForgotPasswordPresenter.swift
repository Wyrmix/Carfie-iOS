//
//  ForgotPasswordPresenter.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class ForgotPasswordPresenter {
    let continueButton: AnimatedCarfieButton
    
    init(continueButton: AnimatedCarfieButton) {
        self.continueButton = continueButton
    }
    
    func present(viewState: ForgotPasswordViewState) {
        if viewState.checkEmailRequestInProgress {
            continueButton.startAnimating()
        } else {
            continueButton.stopAnimating()
        }
    }
}
