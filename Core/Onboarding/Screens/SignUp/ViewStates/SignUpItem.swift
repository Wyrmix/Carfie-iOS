//
//  SignUp.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

/// A representation of sign up fields that require validation.
struct SignUpViewState {
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String?
    let confirmEmail: String?
    let password: String?
    let confirmPassword: String?
}
