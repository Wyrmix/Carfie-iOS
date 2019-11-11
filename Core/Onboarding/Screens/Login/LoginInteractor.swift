//
//  LoginInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class LoginInteractor {
    weak var viewController: LoginViewController?
    weak var delegate: LoginScreenDelegate?
    
    func login() {
        // call login
        
        // present alert on failure
        
//        delegate?.loginComplete()
    }
    
    func cancelLogin() {
        delegate?.loginCancelled()
    }
}
