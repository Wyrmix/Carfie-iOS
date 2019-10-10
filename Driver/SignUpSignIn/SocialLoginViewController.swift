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

    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        authController.loginDelegate = self
    }
}

extension SocialLoginViewController {

    private func initialLoads() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        navigationItem.title = Constants.string.chooseAnAccount.localize()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func didSelect(at indexPath : IndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            authController.login(with: .facebook, andPresenter: self)
            User.main.loginType = LoginType.facebook.rawValue
        case (0,1):
            authController.login(with: .google, andPresenter: self)
            User.main.loginType = LoginType.google.rawValue
        default:
            break
        }
    }

    private func loadAPI(phoneNumber: String?) {

        guard let provider = authController.currentAuthProviderType,
              let accessToken = authController.currentAccessToken else { return }

        var faceBookModel = FacebookLoginModel()
        faceBookModel.accessToken = accessToken
        faceBookModel.device_id = UUID().uuidString
        faceBookModel.device_token = deviceTokenString
        faceBookModel.device_type = DeviceType.ios.rawValue
        faceBookModel.login_by = provider == .facebook ? LoginType.facebook.rawValue : LoginType.google.rawValue
        faceBookModel.mobile = Int(phoneNumber ?? "0")

        let apiType: Base
        switch provider {
        case .facebook:
            apiType = .faceBookLogin
        case .google:
            apiType = .googleLogin
        }

        presenter?.post(api: apiType, data: faceBookModel.toData())
    }

    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
        viewcontroller.uiManager.theme?()?.buttonTextColor = .white
    }

    private func startAccountKitLogin(){
        guard accountKit.currentAccessToken == nil else {
            completeAccountKitLogin()
            return
        }

        let accountKitVC = accountKit.viewControllerForPhoneLogin()
        accountKitVC.enableSendToFacebook = true
        self.prepareLogin(viewcontroller: accountKitVC)
        self.present(accountKitVC, animated: true, completion: nil)
    }

    private func completeAccountKitLogin() {
        accountKit.requestAccount { [weak self] account, _ in
            self?.loadAPI(phoneNumber: account?.phoneNumber?.stringRepresentation())
        }
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

// MARK:- TableView

extension SocialLoginViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellId, for: indexPath) as? SocialLoginCell {
            tableCell.labelTitle.text = (indexPath.row == 0 ? Constants.string.facebook : Constants.string.google).localize()
            tableCell.imageViewTitle.image = indexPath.row == 0 ? #imageLiteral(resourceName: "fb_icon") : #imageLiteral(resourceName: "google_icon")
            return tableCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.didSelect(at: indexPath)
         tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SocialLoginViewController : AKFViewControllerDelegate {
    
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

extension SocialLoginViewController: PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {}

    func getFaceBookAPI(api: Base, data: FacebookLoginModelResponse?) {
        if data != nil {
            UserDefaults.standard.set(data?.access_token, forKey: "access_token")
            User.main.accessToken = data?.access_token
            storeInUserDefaults()
            
            if data?.access_token !=  nil {
                presenter?.get(api: .getProfile, parameters: nil)
            }
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        Common.storeUserData(from: data)
        storeInUserDefaults()
        DispatchQueue.main.async {
            toastSuccess(UIApplication.shared.keyWindow! , message: Constants.string.loginSucess as NSString, smallFont: true, isPhoneX: true, color: UIColor.primary)
            NotificationCenter.default.post(name: .OnboardingDidComplete, object: self)
        }
    }
}

class SocialLoginCell : UITableViewCell {
    @IBOutlet weak var imageViewTitle : UIImageView!
    @IBOutlet weak var labelTitle : UILabel!
    
    override func awakeFromNib() {
        setCommonFont()
    }
    
    private func setCommonFont(){
        setFont(TextField: nil, label: labelTitle, Button: nil, size: nil)
    }
}
