//
//  CarfieSignUpProvider.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/2/19.
//

import Foundation

protocol SignUpProvider {
    /// Delegate for auth completions
    /*weak*/ var delegate: AuthProviderDelegate? { get set }
    
    func loginPostSignUp(_ signUp: SignUpResponse)
}

class CarfieSignUpProvider: SignUpProvider {
    
    weak var delegate: AuthProviderDelegate?
    
    func loginPostSignUp(_ signUp: SignUpResponse) {        
        delegate?.completeLogin(with: .success(provider: .carfie), andAccessToken: signUp.accessToken)
    }
}
