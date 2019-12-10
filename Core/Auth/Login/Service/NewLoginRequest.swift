//
//  LoginRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//

import Foundation

struct NewLoginRequest: NetworkRequest {
    typealias Response = LoginResponse
    
    var path: String {
        switch theme {
        case .driver:
            return "/api/provider/oauth/token"
        case .rider:
            return "/api/user/oauth/token"
        }
    }
    
    let method: HTTPMethod = .POST
    let body: Data?
    
    private let theme: AppTheme
    
    init(theme: AppTheme, login: Login) {
        self.theme = theme
        
        do {
            body = try JSONEncoder().encode(login)
        } catch {
            assertionFailure("SignUp object failed to encode")
            body = nil
        }
    }
}
