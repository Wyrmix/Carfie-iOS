//
//  CarfieAuthProvider.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/1/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

final class CarfieAuthProvider {
    
    let type: AuthProviderType = .carfie
    
    weak var delegate: AuthProviderDelegate?
    
    func loginPostSignUp(_ signUp: SignUpResponse) {
        // TECH-DEBT: move away from singleton User model
        User.main.accessToken = signUp.accessToken
        storeInUserDefaults()
        
        delegate?.completeLogin(with: .success(provider: .carfie), andAccessToken: signUp.accessToken)
        // TODO: get profile
    }
}

extension CarfieAuthProvider: AuthProvider {
    func login(withPresentingViewController viewController: UIViewController) {
        
    }
    
    func logout() {
        
    }
    
    func getAccessToken(completion: @escaping (String?) -> Void) {
        
    }
}
