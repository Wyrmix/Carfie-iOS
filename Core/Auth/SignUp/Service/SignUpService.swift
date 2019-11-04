//
//  SignUpService.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/1/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol SignUpService {
    func signUp(_ signUp: ValidatedSignUp, theme: AppTheme, completion: @escaping (Result<SignUpResponse>) -> Void)
}

class DefaultSignUpService: SignUpService {
    let service: NetworkService
    
    init(service: NetworkService = DefaultNetworkService()) {
        self.service = service
    }
    
    func signUp(_ signUp: ValidatedSignUp, theme: AppTheme, completion: @escaping (Result<SignUpResponse>) -> Void) {
        let request = SignUpRequest(theme: theme, signUpData: signUp)
        service.request(request) { result in
            completion(result)
        }
    }
}
