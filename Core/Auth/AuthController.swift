//
//  AuthController.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/22/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

// MARK: - Protocols

/// The AuthController protocol defines the interface Carfie 3rd-party login providers. It assists
/// in abstracting these providers disparate login processes.
protocol AuthController {

    /// Delegate for login requests
    var loginDelegate: AuthControllerLoginDelegate? { get set }

    /// Delegate for logout requests
    var logoutDelegate: AuthControllerLogoutDelegate? { get set }

    /// Represents the current auth provider for the authenticated user
    var currentAuthProviderType: AuthProviderType? { get set }

    /// The access token for the current auth session. This is set upon login. This property
    /// is only guaranteed to exist after fresh logins.
    ///
    /// If the access token is required outside of the auth flow it should be retrieved by calling
    /// getAccessToken(completion:).
    var currentAccessToken: String? { get }

    /// Fetches the current access token from the active auth provider.
    ///
    /// - Parameter completion: called after successful retrieval of the token from the underlying provider
    ///                         with the access token represented as a String.
    func getAccessToken(completion: ((String?) -> Void)?)
    
    /// Initiate login with Carfie.
    /// - Parameter login: user's login data
    func loginWithCarfie(_ login: Login)

    /// Initiate login with a 3rd party provider. This will transfer the UI flow to the provider.
    /// This will eventually call the login delegate.
    ///
    /// - Parameter authProviderType: the provider to login with.
    /// - Parameter viewController: the view controller that should present the login flow.
    func login(with authProviderType: AuthProviderType, andPresenter viewController: UIViewController)

    /// Logout of the current Auth provider.
    func logout()

    /// Configuration function that should be called on app launch to configure Google client id and delegates.
    ///
    /// - Parameter clientId: Google client id for the app
    func configureGoogleSignIn(with clientId: String)

    /// Configuration function that should be called by AppDelegate.application(_:open:options:) to configure
    /// the OAuth callback url.
    ///
    /// - Parameter url: url to handle
    /// - Returns: boolean value that represents if the app should handle the url request
    func handleGoogleAuthUrl(_ url: URL) -> Bool
    
    /// Initiate a request to permanently revoke all permissions for the active auth provider
    /// - Parameter completion: returns and error if the revocation failed
    func revokeCredentials(completion: @escaping (Error?) -> Void)
    
    func signUp(with signUp: ValidatedSignUp, completion: @escaping (Result<SignUpResponse>) -> Void)
}

// MARK: Delegates

/// Delegate that handles all login requests from the AuthController.
protocol AuthControllerLoginDelegate: class {

    /// This function is called upon completion of a provider's login flow.
    ///
    /// - Parameters:
    ///   - authController: the AuthController that handled the login request
    ///   - result: the result of the login attempt
    func authController(_ authController: AuthController, loginDidCompleteWith result: AuthResult)
}

/// Delegate that handles all logout requests from the AuthController.
protocol AuthControllerLogoutDelegate: class {

    /// This function is called upon completion of a provider's logout flow.
    ///
    /// - Parameters:
    ///   - authController: the AuthController that handled the logout request
    ///   - result: the result of the logout attempt
    func authController(_ authController: AuthController, userDidSignOutWith result: AuthResult)
}

// MARK: - Default AuthController implementation

/// Default AuthController implementation that handles all Auth for Carfie
final class DefaultAuthController {

    /// Singleton Instance
    static func shared(_ theme: AppTheme) -> DefaultAuthController {
        guard let authController = _shared else {
            _shared = AuthControllerFactory.make(with: theme)
            return _shared!
        }
        
        return authController
    }
    
    private static var _shared: DefaultAuthController?

    // MARK: Delegates

    weak var loginDelegate: AuthControllerLoginDelegate?
    weak var logoutDelegate: AuthControllerLogoutDelegate?

    // MARK: Controlled Properties

    var currentAccessToken: String? {
        get {
            // This is a somewhat unfortunate access issue created by Google's SDK providing only asynchronous access
            // to its access tokens. There are certainly some workarounds for this, but will remain a tech debt issue for
            // now and we will rely on the developer not accessing this token when it is nil.
            assert(authRepository.auth.accessToken != nil, "Access token is nil, did you mean to call getAccessToken(completion:)?")
            return authRepository.auth.accessToken
        }
    }

    private var _currentAuthProvider: AuthProvider?

    var currentAuthProviderType: AuthProviderType? {
        get {
            return _currentAuthProvider?.type
        }
        set {
            // This an annoying necessity until all auth and user management can be extracted and refactored from various global scope
            // functions throughout the app. Until that time this property will need to be set on fresh launches to keep things in
            // sync with the user object.
            assert(_currentAuthProvider == nil, "currentAuthProvider should only be set when nil to prevent inconsistencies in AuthProvider's internal state.")
            guard let authProviderType = newValue else {
                _currentAuthProvider = nil
                return
            }
            setCurrentAuthProvider(to: authProviderType)
        }
    }
    
    let theme: AppTheme

    // MARK: Auth Providers

    private var carfieAuthProvider: AuthProvider
    private var facebookAuthProvider: AuthProvider
    private var googleAuthProvider: GoogleAuthProvider
    
    // MARK: Account Creation
    
    private var signUpProvider: SignUpProvider
    
    // MARK: Service
    
    private let profileService: ProfileService
    private let signUpService: SignUpService
    
    // MARK: Persistence
    
    private var authRepository: AuthRepository
    private var profileRepository: ProfileRepository

    // MARK: Init

    init(theme: AppTheme,
         carfieAuthProvider: AuthProvider,
         facebookAuthProvider: AuthProvider,
         googleAuthProvider: GoogleAuthProvider,
         signUpProvider: SignUpProvider,
         profileService: ProfileService,
         signUpService: SignUpService,
         authRepository: AuthRepository,
         profileRepository: ProfileRepository
    ) {
        self.theme = theme
        self.carfieAuthProvider = carfieAuthProvider
        self.facebookAuthProvider = facebookAuthProvider
        self.googleAuthProvider = googleAuthProvider
        self.signUpProvider = signUpProvider
        self.profileService = profileService
        self.signUpService = signUpService
        self.authRepository = authRepository
        self.profileRepository = profileRepository

        self.carfieAuthProvider.delegate = self
        self.facebookAuthProvider.delegate = self
        self.googleAuthProvider.delegate = self
        self.signUpProvider.delegate = self
    }

    // MARK: Private

    private func setCurrentAuthProvider(to authProviderType: AuthProviderType) {
        switch authProviderType {
        case .carfie:
            _currentAuthProvider = carfieAuthProvider
        case .facebook:
            _currentAuthProvider = facebookAuthProvider
        case .google:
            _currentAuthProvider = googleAuthProvider
        }
    }
}

// MARK: - AuthController
extension DefaultAuthController: AuthController {
    func getAccessToken(completion: ((String?) -> Void)?) {
        guard let currentAuthProvider = _currentAuthProvider else {
            completion?(nil)
            return
        }

        currentAuthProvider.getAccessToken { [weak self] token in
            self?.authRepository.auth = CarfieAuth(accessToken: token)
            completion?(token)
        }
    }
    
    func loginWithCarfie(_ login: Login) {
        setCurrentAuthProvider(to: .carfie)
        carfieAuthProvider.login(with: login)
    }

    func login(with authProviderType: AuthProviderType, andPresenter viewController: UIViewController) {
        setCurrentAuthProvider(to: authProviderType)
        _currentAuthProvider?.login(withPresentingViewController: viewController)
    }

    func logout() {
        guard let authProvider = _currentAuthProvider else {
            // TECH DEBT: workaround until Carfie login is incorporated into this controller.
            NotificationCenter.default.post(name: .UserDidLogout, object: self)
            return
        }

        authProvider.logout()
    }

    func configureGoogleSignIn(with clientId: String) {
        googleAuthProvider.configureGoogleSignIn(with: clientId)
    }

    func handleGoogleAuthUrl(_ url: URL) -> Bool {
        return googleAuthProvider.handleGoogleAuthUrl(url)
    }
    
    func revokeCredentials(completion: @escaping (Error?) -> Void) {
        _currentAuthProvider?.revoker?.revoke(completion: completion)
    }
    
    func signUp(with signUp: ValidatedSignUp, completion: @escaping (Result<SignUpResponse>) -> Void) {
        signUpService.signUp(signUp, theme: theme) { result in
            do {
                let signUp = try result.resolve()
                self.signUpProvider.loginPostSignUp(signUp)
                completion(result)
            } catch {
                completion(result)
            }
        }
    }
}

// MARK: - AuthProviderDelegate
extension DefaultAuthController: AuthProviderDelegate {
    func completeLogin(with result: AuthResult, andAccessToken token: String?) {
        switch result {
        case .success(let provider):
            setCurrentAuthProvider(to: provider)
            authRepository.auth = CarfieAuth(accessToken: token)
            NotificationCenter.default.post(name: .UserDidLogin, object: self)
        case .cancel, .failure:
            _currentAuthProvider = nil
            authRepository.auth = CarfieAuth(accessToken: nil)
        }

        loginDelegate?.authController(self, loginDidCompleteWith: result)
    }

    func completeLogout(with result: AuthResult) {
        _currentAuthProvider = nil
        authRepository.auth = CarfieAuth(accessToken: nil)
        profileRepository.profile = nil
        logoutDelegate?.authController(self, userDidSignOutWith: result)
        NotificationCenter.default.post(name: .UserDidLogout, object: self)
    }
}
