//
//  SignUpViewPresenter.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//

import Foundation

final class SignUpViewPresenter {
    let signUpView: SignUpView
    
    init(signUpView: SignUpView) {
        self.signUpView = signUpView
    }
    
    func present(emailInUseMessage: String) {
        signUpView.present(emailInUseMessage)
    }
}
