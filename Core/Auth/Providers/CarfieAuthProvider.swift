//
//  CarfieAuthProvider.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/1/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

final class CarfieAuthProvider: AuthProvider {
    
    let type: AuthProviderType = .carfie
    
    weak var delegate: AuthProviderDelegate?
    
    private let theme: AppTheme
    private let loginService: LoginService
    
    init(theme: AppTheme, loginService: LoginService = DefaultLoginService()) {
        self.theme = theme
        self.loginService = loginService
    }
    
    func login(with login: Login) {
        loginService.login(login, theme: theme) { result in
            do {
                let response: LoginResponse = try result.resolve()
                self.delegate?.completeLogin(with: .success(provider: .carfie), andAccessToken: response.accessToken)
            } catch {
                self.delegate?.completeLogin(with: .failure(error: error), andAccessToken: nil)
            }
        }
    }
    
    func logout() {
        // TODO: this eventually needs to actually call the logout logic, but for now that is contained in each
        // app target.
        delegate?.completeLogout(with: .success(provider: .carfie))
    }
    
    func getAccessToken(completion: @escaping (String?) -> Void) {
        
    }
}
