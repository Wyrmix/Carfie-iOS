//
//  DriverSignUpRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct SignUpRequest: NetworkRequest {
    typealias Response = SignUpResponse
    
    var path: String {
        switch theme {
        case .driver:
            return "/api/provider/register"
        case .rider:
            return "/api/user/signup"
        }
    }
    
    let method: HTTPMethod = .POST
    let body: Data?
    
    private let theme: AppTheme
    
    init(theme: AppTheme, signUpData: ValidatedSignUp) {
        self.theme = theme
        
        do {
            body = try JSONEncoder().encode(signUpData)
        } catch {
            assertionFailure("SignUp object failed to encode")
            body = nil
        }
    }
}
