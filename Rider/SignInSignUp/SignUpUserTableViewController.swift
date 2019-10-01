//
//  SignUpUserTableViewController.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import AccountKit
import UIKit

class SignUpUserTableViewController: UITableViewController {
    
    @IBOutlet var firstNameText: HoshiTextField!
    @IBOutlet var emailtext: HoshiTextField!
    @IBOutlet var lastNameText: HoshiTextField!
    @IBOutlet var passwordText: HoshiTextField!
    @IBOutlet var confirmPwdText: HoshiTextField!
    @IBOutlet var phoneNumber: HoshiTextField!
    @IBOutlet var nextView: UIView!
    @IBOutlet var nextImage: UIImageView!
    
    private var userInfo : UserData?
    private var accountKit : AKFAccountKit?

    private lazy var authValidator: AuthValidator = {
        return AuthValidator()
    }()

    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationcontroller()        
        self.setDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.changeNextButtonFrame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.nextView.isHidden = false
        self.changeNextButtonFrame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.nextView.isHidden = true
        super.viewWillDisappear(animated)
    }
}

extension SignUpUserTableViewController {

    // MARK:- Designs
    
    private func setDesign() {
        Common.setFont(to: firstNameText)
        Common.setFont(to: emailtext)
        Common.setFont(to: lastNameText)
        Common.setFont(to: passwordText)
        Common.setFont(to: confirmPwdText)
        Common.setFont(to: phoneNumber)
    }
    
    
    private func localize(){
        self.firstNameText.placeholder = Constants.string.first.localize()
        self.lastNameText.placeholder = Constants.string.last.localize()
        self.emailtext.placeholder = Constants.string.emailPlaceHolder.localize()
        self.passwordText.placeholder = Constants.string.password
        self.confirmPwdText.placeholder = Constants.string.ConfirmPassword.localize()
        self.phoneNumber.placeholder = Constants.string.phoneNumber.localize()
        self.passwordText.placeholder = Constants.string.password.localize()
    }
    
    func setNavigationcontroller(){
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.barTintColor = UIColor.white
        }
        
        title = Constants.string.registerDetails.localize()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(self.backButtonClick))
        addGustureforNextBtn()
        view.dismissKeyBoardonTap()

        [firstNameText, lastNameText, emailtext, passwordText, confirmPwdText, phoneNumber].forEach {
            $0?.delegate = self
        }

        navigationController?.view.addSubview(nextView)
    }
    
    
    
    
    private func addGustureforNextBtn(){
        let nextBtnGusture = UITapGestureRecognizer(target: self, action: #selector(nextBtnTapped(sender:)))
        self.nextView.addGestureRecognizer(nextBtnGusture)
    }
    
    
    @IBAction func nextBtnTapped(sender : UITapGestureRecognizer){
        self.view.endEditingForce()
        guard let email = self.validateEmail() else { return }
        
        guard let firstName = self.firstNameText.text, !firstName.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterFirstName.localize())
            return
        }
        guard let lastName = lastNameText.text, !lastName.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterLastName.localize())
            return
        }
       
        guard let phoneNumber = phoneNumber.text, !phoneNumber.isEmpty, let mobile = Int(phoneNumber)  else {
            self.showToast(string: ErrorMessage.list.enterMobileNumber.localize())
            return
        }
        guard let password = passwordText.text, !password.isEmpty, password.count>=6 else {
             self.showToast(string: ErrorMessage.list.enterPassword.localize())
            return
        }
        guard let confirmPwd = confirmPwdText.text, !confirmPwd.isEmpty else {
             self.showToast(string: ErrorMessage.list.enterConfirmPassword.localize())
            return
        }
        guard confirmPwd == password else {
            self.showToast(string: ErrorMessage.list.passwordDonotMatch.localize())
            return
        }
        userInfo =  MakeJson.signUp(loginBy: .manual, email: email, password: password, socialId: nil, firstName: firstName, lastName: lastName, mobile: mobile)

       self.accountKit = AKFAccountKit(responseType: .accessToken)
       let akPhone = AKFPhoneNumber(countryCode: "in", phoneNumber: phoneNumber)
       let accountKitVC = accountKit?.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
       accountKitVC!.enableSendToFacebook = true
       self.prepareLogin(viewcontroller: accountKitVC!)
       self.present(accountKitVC!, animated: true, completion: nil)
      
        
    }
    
    private func validateEmail() -> String? {
        do {
            let email = try authValidator.validateEmail(emailtext.text).resolve()
            return email
        } catch let error as EmailValidationError {
            switch error {
            case .noEmailEntered:
                showToast(string: ErrorMessage.list.enterEmail.localize())
            case .notAValidEmail:
                self.showToast(string: ErrorMessage.list.enterValidEmail.localize())
            }

            emailtext.becomeFirstResponder()
            return nil
        } catch {
            return nil
        }
    }

    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
    }

    private func showToast(string : String?) {
         self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }

    private func changeNextButtonFrame() {
        let frameWidth : CGFloat = 50 * (UIScreen.main.bounds.width/375)
        self.nextView.makeRoundedCorner()
        self.nextView.frame = CGRect(x: UIScreen.main.bounds.width-(frameWidth+16), y: UIScreen.main.bounds.height-(frameWidth+16), width: frameWidth, height: frameWidth)
        self.nextImage.frame = CGRect(x: self.nextView.frame.width/4, y: self.nextView.frame.height/4, width: self.nextView.frame.width/2, height: self.nextView.frame.height/2)
    }
}


extension SignUpUserTableViewController : RiderPostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
    
        if api == .userVerify {
            self.emailtext.shake()
            vibrate(with: .weak)
            DispatchQueue.main.async {
                self.emailtext.becomeFirstResponder()
            }
        }
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.showToast(string: message)
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        
        loader.isHideInMainThread(true)
        
        if api == .signUp, data != nil, data?.access_token != nil {
            User.main.accessToken = data?.access_token
            Common.storeUserData(from: data)
            storeInUserDefaults()
            self.navigationController?.present(Common.setDrawerController(), animated: true, completion: nil)
            return
        }
    }
}

//MARK:- AKFViewControllerDelegate

extension SignUpUserTableViewController : AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        func dismiss() {
            viewController.dismiss(animated: true) { }
            self.loader.isHidden = false
            self.presenter?.post(api: .signUp, data: self.userInfo?.toData())
        }
        if accountKit != nil {
            accountKit!.requestAccount({ (account, error) in
                if let phoneNumber = account?.phoneNumber {
                    var mobileString = phoneNumber.stringRepresentation()
                    if mobileString.hasPrefix("+") {
                        mobileString.removeFirst()
                        if let mobileInt = Int(mobileString) {
                            self.userInfo?.mobile = mobileInt
                        }
                    }
                }
                dismiss()
                return
            })
        } else {
            dismiss()
        }
    }
}

// MARK:- UITextFieldDelegate

extension SignUpUserTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as? HoshiTextField)?.borderActiveColor = .primary
        if textField == emailtext {
        textField.placeholder = Constants.string.email.localize() }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? HoshiTextField)?.borderActiveColor = .lightGray
        if textField == emailtext {
            if textField.text?.count == 0 {
                textField.placeholder = Constants.string.emailPlaceHolder.localize()
            } else if let email = validateEmail() {
                textField.resignFirstResponder()
                let user = User()
                user.email = email
                presenter?.post(api: .userVerify, data: user.toData())
            }
        }
    }
}
