//
//  MockSignUpProvider.swift
//  CoreTests
//
//  Created by Christopher Olsen on 11/2/19.
//

import Foundation

class MockSignUpProvider: SignUpProvider {
    
    weak var delegate: AuthProviderDelegate?
    
    func loginPostSignUp(_ signUp: SignUpResponse) {
        
    }
}
