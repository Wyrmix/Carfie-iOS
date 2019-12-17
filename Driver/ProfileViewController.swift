//
//  ProfileViewController.swift
//  User
//
//  Created by CSS on 04/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
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
    
    private let profileController = CarfieProfileController()
    
    private var changedImage : UIImage?
    let profile = profilePostModel()
    var servicemodel = ServiceModel()
    var phoneNumber = String()
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        navigationItem.title = Constants.string.profile.localize()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = ""
        addButtonTargets()
    }
    
    private func addButtonTargets() {
        viewPersonal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTripTypeAction(sender:))))
        viewBusiness.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTripTypeAction(sender:))))
        buttonSave.addTarget(self, action: #selector(buttonSaveAction), for: .touchUpInside)
        view.dismissKeyBoardonTap()
    }
}

// MARK:- Methods

extension ProfileViewController {
    
    private func initialLoads() {
        getProfile()
        self.localize()
        self.setDesign()
        self.setProfile()
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
        
        
        
        let basicProfileInfo = BasicProfileInfo(firstName: firstName, lastName: lastName, email: email, mobile: phoneNumber)
        
        self.loader.isHidden = false
        
        profileController.updateBasicProfileInfo(basicProfileInfo, theme: .driver) { [weak self] result in
            self?.loader.isHidden = true
            
            do {
                let profile = try result.resolve()

                // Patch since service details not provided from backend
                User.main.serviceType = User.main.serviceType
                User.main.serviceId = User.main.serviceId
                
                Common.storeUserData(from: profile)
                storeInUserDefaults()
                self?.setProfile()
            } catch {
                
            }
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
        guard let profile = DefaultProfileRepository().profile else { return }
        let viewController = ChangePasswordViewController.viewController(for: .update, and: profile)
        navigationController?.pushViewController(viewController, animated: true)
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
        DefaultAuthController.shared(.driver).revokeCredentials { error in
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
