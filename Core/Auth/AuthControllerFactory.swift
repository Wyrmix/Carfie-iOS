//
//  AuthControllerFactory.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/1/19.
//

import Foundation

struct AuthControllerFactory {
    static func make(with theme: AppTheme) -> DefaultAuthController {
        let carfieAuthProvider = CarfieAuthProvider(theme: theme)
        let facebookProvider = FacebookAuthProvider()
        let googleAuthProvider = DefaultGoogleAuthProvider()
        let signUpProvider = CarfieSignUpProvider()
        let profileService = DefaultProfileService()
        let signUpService = DefaultSignUpService()
        let authRepository = DefaultAuthRepository()
        
        return DefaultAuthController(
            theme: theme,
            carfieAuthProvider: carfieAuthProvider,
            facebookAuthProvider: facebookProvider,
            googleAuthProvider: googleAuthProvider,
            signUpProvider: signUpProvider,
            profileService: profileService,
            signUpService: signUpService,
            authRepository: authRepository
        )
    }
}
