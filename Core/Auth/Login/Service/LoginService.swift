//
//  LoginService.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//

import Foundation

protocol LoginService {
    func login(_ login: Login, theme: AppTheme, completion: @escaping (Result<LoginResponse>) -> Void)
}

class DefaultLoginService: LoginService {
    let service: NetworkService
    
    init(service: NetworkService = DefaultNetworkService()) {
        self.service = service
    }
    
    func login(_ login: Login, theme: AppTheme, completion: @escaping (Result<LoginResponse>) -> Void) {
        let request = NewLoginRequest(theme: theme, login: login)
        service.request(request) { result in
            completion(result)
        }
    }
}
