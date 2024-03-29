//
//  AuthProvider.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// Auth Providers that the controller can handle.
///
/// - facebook: facebook account login
/// - google: google account login
public enum AuthProviderType: String {
    case carfie
    case facebook
    case google
}

/// Result object for all login and logout actions.
///
/// - cancel: auth action was cancelled by the user
/// - failure: auth action failed with an associated error
/// - success: auth action was successful with an associated AuthProvider
public enum AuthResult {
    case cancel
    case failure(error: Error)
    case success(provider: AuthProviderType)
}

/// Delegate for passing auth event data between the AuthController and its AuthProviders
protocol AuthProviderDelegate: class {
    func completeLogin(with result: AuthResult, andAccessToken token: String?)
    func completeLogout(with result: AuthResult)
}

/// An login and logout provider.
protocol AuthProvider {

    /// Auth provider's type (e.g. facebook)
    var type: AuthProviderType { get }
    
    /// Revoker that provides functionality for revoking all app permissions for the provider type
    /// Note: only Facebook currently requires this property
    var revoker: CredentialRevoker? { get }

    /// Delegate for auth completions
    var delegate: AuthProviderDelegate? { get set }

    /// Login with an AuthProvider
    ///
    /// - Parameter viewController: the login flow's presenting view controller
    func login(withPresentingViewController viewController: UIViewController)
    
    /// Login using a Login object. Used for Carfie login
    /// - Parameter login: login data
    func login(with login: Login)

    /// Logout with an AuthProvider
    func logout()

    /// Asynchronously retrieve an access token from the provider
    ///
    /// - Parameter completion: called upon completion of retrieval attempt
    func getAccessToken(completion: @escaping (String?) -> Void)
}

// Default implementations
extension AuthProvider {
    var revoker: CredentialRevoker? {
        return nil
    }
    
    func login(with login: Login) {}
    func login(withPresentingViewController viewController: UIViewController) {}
}
