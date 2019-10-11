//
//  ProfileViewController.swift
//  User
//
//  Created by CSS on 04/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AccountKit

class ProfileViewController: UITableViewController {
    
    @IBOutlet private weak var viewImageChange : UIView!
    @IBOutlet private weak var imageViewProfile : UIImageView!
    @IBOutlet private weak var textFieldFirst : HoshiTextField!
    @IBOutlet private weak var textFieldLast : HoshiTextField!
    @IBOutlet private weak var textFieldPhone : HoshiTextField!
    @IBOutlet private weak var textFieldEmail : HoshiTextField!
    @IBOutlet private weak var buttonSave : UIButton!
    @IBOutlet private weak var buttonChangePassword : UIButton!
    @IBOutlet private weak var labelBusiness : UILabel!
    @IBOutlet private weak var labelPersonal : UILabel!
    @IBOutlet private weak var labelTripType : UILabel!
    @IBOutlet private weak var imageViewBusiness : UIImageView!
    @IBOutlet private weak var imageViewPersonal : UIImageView!
    @IBOutlet private weak var viewBusiness : UIView!
    @IBOutlet private weak var viewPersonal : UIView!
    
    @IBOutlet var textFieldServiceType: HoshiTextField!
    
    private var changedImage : UIImage?
    let profile = profilePostModel()
    var servicemodel = ServiceModel()
    var phoneNumber = String()
    var data : Data?
    let accountKit = AKFAccountKit(responseType: .accessToken)
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayout()
    }
}

// MARK:- Methods

extension ProfileViewController {
    
    private func initialLoads() {
        
        self.viewPersonal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setTripTypeAction(sender:))))
        self.viewBusiness.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setTripTypeAction(sender:))))
        self.viewImageChange.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeImage)))
        self.buttonSave.addTarget(self, action: #selector(self.buttonSaveAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.profile.localize()
        getProfile()
        self.localize()
        self.setDesign()
        self.setProfile()
        self.view.dismissKeyBoardonTap()
        
        setupChangePasswordButton()
    }
    
    private func setupChangePasswordButton() {
        guard let loginString = User.main.loginType, let loginType = LoginType(rawValue: loginString) else { return }
        
        switch loginType {
        case .manual:
            buttonChangePassword.setTitle(Constants.string.lookingToChangePassword.localize(), for: .normal)
            buttonChangePassword.addTarget(self, action: #selector(changePasswordAction), for: .touchUpInside)
            buttonChangePassword.isHidden = false
        case .facebook:
            buttonChangePassword.setTitle("Revoke Facebook permissions", for: .normal)
            buttonChangePassword.addTarget(self, action: #selector(showRevokePermissionsDialog), for: .touchUpInside)
            buttonChangePassword.isHidden = false
        case .google:
            buttonChangePassword.isHidden = true
        }
    }
    
    private func getProfile(){
        
        self.presenter?.get(api: .getProfile, parameters: nil)
        
    }
    
    // MARK:- Set Profile Details
    
    private func setProfile(){
        Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(String(describing: User.main.picture ?? "0"))") { (image) in
            DispatchQueue.main.async {
                self.imageViewProfile.image = image == nil ? #imageLiteral(resourceName: "young-male-avatar-image") : image
            }
        }
        
        self.textFieldFirst.text = User.main.firstName
        self.textFieldLast.text = User.main.lastName
        self.textFieldEmail.text = User.main.email
        self.textFieldPhone.text = User.main.mobile
        self.textFieldServiceType.text = User.main.serviceType
    }
    
    //MARK:- Set Designs
    
    private func setDesign() {
        
        var attributes : [ NSAttributedString.Key : Any ] = [.font : UIFont(name: FontCustom.medium.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)]
        attributes.updateValue(UIColor.white, forKey: NSAttributedString.Key.foregroundColor)
        self.buttonSave.setAttributedTitle(NSAttributedString(string: Constants.string.save.localize().uppercased(), attributes: attributes), for: .normal)
        [textFieldFirst, textFieldLast, textFieldEmail, textFieldPhone, textFieldServiceType].forEach({
            $0?.borderInactiveColor = nil
            $0?.borderActiveColor = nil
            Common.setFont(to: $0!)
        })
    }
    
    // MARK:- Show Image
    
    @IBAction private func changeImage(){
        self.showImage { (image) in
            if image != nil {
                self.imageViewProfile.image = image
                self.changedImage = image
            }
        }
    }
    
    
    // MARK:- Trip Type Action
    
    @IBAction private func setTripTypeAction(sender : UITapGestureRecognizer) { }
    
    // MARK:- Update Profile Details
    
    @IBAction func buttonSaveAction(){
        
        self.view.endEditingForce()
        
        guard let firstName = self.textFieldFirst.text, firstName.count>0 else {
            vibrate(sound: .cancelled)
            textFieldFirst.shake()
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterFirstName.localize())
            return
        }
        
        guard let lastName = self.textFieldLast.text, lastName.count>0 else {
            vibrate(sound: .cancelled)
            textFieldLast.shake()
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterLastName.localize())
            return
        }
        
        guard let email = validateField(textFieldEmail.text, with: EmailValidator()),
              let phoneNumber = validateField(textFieldPhone.text, with: PhoneValidator()) else { return }
                
        if self.changedImage != nil, let dataImg = self.changedImage?.pngData() {
            data = dataImg
        }
        servicemodel.service = User.main.serviceId
        
        profile.device_token = deviceTokenString
        profile.email = email
        profile.first_name = firstName
        profile.last_name = lastName
        profile.mobile = phoneNumber
        profile.service = servicemodel.service
        self.loader.isHidden = false

        if data == nil {
            self.presenter?.post(api: .updateProfile, data: profile.toData())
        } else {
            var json = profile.JSONRepresentation
            json.removeValue(forKey: "id")
            json.removeValue(forKey: "picture")
            json.removeValue(forKey: "access_token")
            json.removeValue(forKey: "avatar")
            json.removeValue(forKey : "service")
            self.presenter?.post(api: .updateProfile, imageData: [WebConstants.string.picture : data!], parameters: json)
        }
    }
    
    private func validateField(_ field: String?, with validator: Validator) -> String? {
        do {
            let field = try FieldValidator(validator: validator).validate(field).resolve()
            return field
        } catch let error as ValidationError {
            vibrate(sound: .cancelled)
            textFieldPhone.shake()
            UIScreen.main.focusedView?.make(toast: error.errorMessage)
            return nil
        } catch {
            vibrate(sound: .cancelled)
            textFieldPhone.shake()
            return nil
        }
    }

    
    private func setLayout(){
        
        self.imageViewProfile.makeRoundedCorner()
        
    }
    
    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
        viewcontroller.uiManager.theme?()?.buttonTextColor = .white
    }
    
    // MARK:- Localize
    
    private func localize() {
        self.textFieldFirst.placeholder = Constants.string.firsrName.localize()
        self.textFieldLast.placeholder = Constants.string.lastName.localize()
        self.textFieldPhone.placeholder = Constants.string.phoneNumber.localize()
        self.textFieldEmail.placeholder = Constants.string.email.localize()
        self.textFieldServiceType.placeholder = Constants.string.service.localize()
    }
    
    //MARK:- Button Change Password Action
    
    @IBAction private func changePasswordAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChangeResetPasswordController) as? ChangeResetPasswordController {
            vc.isChangePassword = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func showRevokePermissionsDialog() {
        UserFacingDestructiveErrorIntent(
            title: "Revoke Credentials",
            message: "Are you sure you want to revoke Facebook? This will permanently remove Facebook authorization and log you out of the app.",
            destructiveTitle: "Yes, I'm sure",
            destructiveAction: { _ in
                self.revokeCredentials()
            }).execute(via: self)
    }
    
    private func revokeCredentials() {
        DefaultAuthController.shared.revokeCredentials { error in
            guard error == nil else {
                UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: self)
                return
            }
            
            forceLogout()
        }
    }
}


// MARK:- TextField Delegate

extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as! HoshiTextField).borderInactiveColor = UIColor.lightGray
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as! HoshiTextField).borderActiveColor = UIColor.primary
    }
}


// MARK:- ScrollView Delegate

extension ProfileViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y<0 else { return }
        let inset = abs(scrollView.contentOffset.y/imageViewProfile.frame.height)
        self.imageViewProfile.transform = CGAffineTransform(scaleX: 1+inset, y: 1+inset)
    }
}

extension ProfileViewController : AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        self.loader.isHidden = true
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        accountKit.requestAccount { (account, error) in
            self.phoneNumber = account?.phoneNumber?.stringRepresentation() ?? ""
            self.profile.mobile = self.phoneNumber
            
        }
        
        viewController.dismiss(animated: true) {
            self.loader.isHidden = false
            if self.data == nil {
                self.presenter?.post(api: .updateProfile, data: self.profile.toData())
            } else {
                var json = self.profile.JSONRepresentation
                json.removeValue(forKey: "id")
                json.removeValue(forKey: "picture")
                json.removeValue(forKey: "access_token")
                json.removeValue(forKey: "avatar")
                json.removeValue(forKey : "service")
                self.presenter?.post(api: .updateProfile, imageData: [WebConstants.string.picture : self.data!], parameters: json)
            }
        }
    }
}


// MARK:- PostviewProtocol

extension ProfileViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.view.make(toast: message)
            self.loader.isHidden = true
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        if api == .updateProfile {
            toastSuccess(self.view, message: Constants.string.profileUpdatedSucess as NSString, smallFont: true, isPhoneX: true, color: .primary)
            let serviceType = User.main.serviceType  // Patch since service details not provided from backend 
            let serviceId = User.main.serviceId
            Common.storeUserData(from: data)
            User.main.serviceType = serviceType
            User.main.serviceId = serviceId
            storeInUserDefaults()
            DispatchQueue.main.async {
                self.loader.isHidden = true
                self.setProfile()
            }
        } else {
            Common.storeUserData(from: data)
            storeInUserDefaults()
            DispatchQueue.main.async {
                self.loader.isHidden = true
                self.setProfile()
            }
        }
    }
}
