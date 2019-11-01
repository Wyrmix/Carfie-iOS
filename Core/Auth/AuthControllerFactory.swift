//
//  AuthControllerFactory.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/1/19.
//

import Foundation

struct AuthControllerFactory {
    static func make(with theme: AppTheme) -> DefaultAuthController {
        let carfieAuthProvider = CarfieAuthProvider()
        let facebookProvider = FacebookAuthProvider()
        let googleAuthProvider = DefaultGoogleAuthProvider()
        let profileService = DefaultProfileService()
        let signUpService = DefaultSignUpService()
        
        return DefaultAuthController(
            theme: theme,
            carfieAuthProvider: carfieAuthProvider,
            facebookAuthProvider: facebookProvider,
            googleAuthProvider: googleAuthProvider,
            profileService: profileService,
            signUpService: signUpService
        )
    }
}
