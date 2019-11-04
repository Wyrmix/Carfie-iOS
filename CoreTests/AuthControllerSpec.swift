//
//  AuthControllerSpec.swift
//  CarfieCoreTests
//
//  Created by Christopher Olsen on 9/25/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Nimble
import Quick

//@testable import Driver

class AuthControllerSpec: QuickSpec {
    override func spec() {
        describe("An AuthController") {
            var subject: AuthController!

            var carfieAuthProvider: MockAuthProvider!
            var facebookAuthProvider: MockAuthProvider!
            var googleAuthProvider: MockAuthProvider!
            var signUpProvider: MockSignUpProvider!
            var authRepository: MockAuthRepository!

            beforeEach {
                carfieAuthProvider = MockAuthProvider(type: .carfie)
                facebookAuthProvider = MockAuthProvider(type: .facebook)
                googleAuthProvider = MockAuthProvider(type: .google)
                signUpProvider = MockSignUpProvider()
                authRepository = MockAuthRepository()
                
                subject = DefaultAuthController(
                    theme: .rider,
                    carfieAuthProvider: carfieAuthProvider,
                    facebookAuthProvider: facebookAuthProvider,
                    googleAuthProvider: googleAuthProvider,
                    signUpProvider: signUpProvider,
                    profileService: MockProfileService(),
                    signUpService: MockSignUpService(),
                    authRepository: authRepository
                )
            }

            context("on login") {
                it("should set the correct auth provider on a successful login") {
                    facebookAuthProvider.loginResult = AuthResult.success(provider: .facebook)
                    subject.login(with: .facebook, andPresenter: UIViewController(nibName: nil, bundle: nil))
                    expect(subject.currentAuthProviderType).to(equal(.facebook))

                    googleAuthProvider.loginResult = AuthResult.success(provider: .google)
                    subject.login(with: .google, andPresenter: UIViewController(nibName: nil, bundle: nil))
                    expect(subject.currentAuthProviderType).to(equal(.google))
                }

                it("should not set an auth provider on a failed login") {
                    googleAuthProvider.loginResult = AuthResult.failure(error: MockAuthError.mockError)
                    subject.login(with: .google, andPresenter: UIViewController(nibName: nil, bundle: nil))
                    expect(subject.currentAuthProviderType).to(beNil())
                }
            }

            context("on logout") {
                it("should remove the current auth provider") {
                    facebookAuthProvider.logoutResult = AuthResult.success(provider: .facebook)
                    facebookAuthProvider.logout()
                    expect(subject.currentAuthProviderType).to(beNil())
                }

                it("should not allow access to a nil accessToken") {
                    facebookAuthProvider.logoutResult = AuthResult.success(provider: .facebook)
                    facebookAuthProvider.logout()
                    expect { _ = subject.currentAccessToken }.to(throwAssertion())
                }
            }

            context("current auth provider type") {
                it("should only allow setting to new values if nil") {
                    subject.currentAuthProviderType = .facebook
                    expect(subject.currentAuthProviderType).to(equal(.facebook))
                }

                it("should not allow setting to new values if it has a current value") {
                    subject.currentAuthProviderType = .facebook
                    expect { subject.currentAuthProviderType = .google }.to(throwAssertion())
                }
            }
        }
    }
}
