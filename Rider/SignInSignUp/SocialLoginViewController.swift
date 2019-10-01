//
//  SocailLoginViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import AccountKit
import UIKit

class SocialLoginViewController: UITableViewController {

    private lazy var accountKit = AKFAccountKit(responseType: .accessToken)
    
    private let authController = DefaultAuthController.shared
    private let tableCellId = "SocialLoginCell"

    private lazy var loader : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authController.loginDelegate = self
    }
}

// MARK:- Methods

extension SocialLoginViewController {
    private func initialLoads() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:  #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        navigationItem.title = Constants.string.chooseAnAccount.localize()
        navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func didSelect(at indexPath : IndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (_, 0):
            authController.login(with: .facebook, andPresenter: self)
            User.main.loginType = LoginType.facebook.rawValue
        case (_, 1):
            authController.login(with: .google, andPresenter: self)
            User.main.loginType = LoginType.google.rawValue
        default:
            break
        }
    }
    
    private func loadAPI(phoneNumber: Int?){
        self.loader.isHidden = false

        guard let provider = authController.currentAuthProviderType,
              let accessToken = authController.currentAccessToken else { return }

        let user = UserData()
        user.accessToken = accessToken
        user.device_id = UUID().uuidString
        user.device_token = deviceTokenString
        user.device_type = .ios
        user.login_by = provider == .facebook ? .facebook : .google
        user.mobile = phoneNumber

        let apiType: Base
        switch provider {
        case .facebook:
            apiType = .facebookLogin
        case .google:
            apiType = .googleLogin
        }

        self.presenter?.post(api: apiType, data: user.toData())
    }

    private func startAccountKitLogin() {
        // check if user is already logged into AccountKit
        guard accountKit.currentAccessToken != nil else {
            let accountKitVC = accountKit.viewControllerForPhoneLogin()
            accountKitVC.enableSendToFacebook = true
            prepareLogin(viewcontroller: accountKitVC)
            present(accountKitVC, animated: true, completion: nil)
            return
        }

        completeAccountKitLogin()
    }
    
    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
    }
}

extension SocialLoginViewController: AuthControllerLoginDelegate {
    func authController(_ authController: AuthController, loginDidCompleteWith result: AuthResult) {
        switch result {
        case .cancel, .failure:
            break
        case .success:
            startAccountKitLogin()
        }
    }
}

// MARK:- AKFViewControllerDelegate
extension SocialLoginViewController : AKFViewControllerDelegate {

    func completeAccountKitLogin() {
        accountKit.requestAccount { [weak self] (account, _) in
            guard let number = account?.phoneNumber?.phoneNumber, let code = account?.phoneNumber?.countryCode, let numberInt = Int(code+number) else {
                self?.onError(api: .addPromocode, message: .Empty, statusCode: 0)
                return
            }
            self?.loadAPI(phoneNumber: numberInt)
        }
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        viewController.dismiss(animated: true) {
            self.completeAccountKitLogin()
        }
    }
}

// MARK:- TableView

extension SocialLoginViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId) as? SocialLoginCell else {
            fatalError("SocialLoginCell is missing")
        }

        cell.labelTitle.text = (indexPath.row == 0 ? Constants.string.facebook : Constants.string.google).localize()
        cell.imageViewTitle.image = indexPath.row == 0 ?  #imageLiteral(resourceName: "fb_icon") :  #imageLiteral(resourceName: "google_icon")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SocialLoginViewController : RiderPostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }

    func getProfile(api: Base, data: Profile?) {
        if api == .getProfile {
            Common.storeUserData(from: data)
            storeInUserDefaults()
            self.navigationController?.present(Common.setDrawerController(), animated: true, completion: nil)
        }
        loader.isHideInMainThread(true)
    }
    
    func getOath(api: Base, data: LoginRequest?) {
        if api == .facebookLogin || api == .googleLogin, let accessTokenString = data?.access_token {
            User.main.accessToken = accessTokenString
            User.main.refreshToken =  data?.refresh_token
            self.presenter?.get(api: .getProfile, parameters: nil)
        }
    }
}

class SocialLoginCell : UITableViewCell {
    @IBOutlet weak var imageViewTitle : UIImageView!
    @IBOutlet weak var labelTitle : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDesign()
    }
    
    private func setDesign() {
        Common.setFont(to: self.labelTitle, isTitle: true)
    }
}
