//
//  SignUpTableViewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AccountKit

class SignUpTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    
    //MARK:- TextField outlets:
    @IBOutlet weak var EmailTxt: HoshiTextField!
    @IBOutlet var lastNametext: HoshiTextField!
    @IBOutlet weak var FirstName: HoshiTextField!

    @IBOutlet weak var Emailtext: HoshiTextField!

    @IBOutlet var textFieldPhoneNumber: HoshiTextField!
    
    @IBOutlet var textFieldPassword: HoshiTextField!
    
    @IBOutlet weak var fieldConfirmPassword: HoshiTextField!
    
    @IBOutlet var nextImage: UIImageView!
    @IBOutlet var nextView: UIView!
    //MARK:- UIlabel outlets

    //MARK:- UIview outlets
    @IBOutlet var textFieldCollection: [HoshiTextField]!
    

    @IBOutlet var vehiclePhotoView: UIView!

    
    //MARK:- imageView outlets:
    

    
    var phoneNumber = String()
    let accountKit = AKFAccountKit(responseType: .accessToken)
    private lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    private var userSignUpInfo : UserData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeNextButtonFrame()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        textFieldCollection.append(fieldConfirmPassword)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.nextImage.isHidden = false
      
        self.SetNavigationcontroller()
        self.unsetSelection()

        self.localization()
       
        self.addGustureforNextBtn()
        setCommonFont()
       //self.perform(#selector(self.addGustureForNextIcon), with: self, afterDelay: 2)
    }
    
    override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         self.nextView.makeRoundedCorner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.nextView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.nextView.isHidden = false
    }

    deinit {
        self.nextView.removeFromSuperview()
    }
   
}




extension SignUpTableViewController {
    
    private func localization(){
        EmailTxt.placeholder = Constants.string.email.localize()
        FirstName.placeholder = Constants.string.firsrName.localize()
        lastNametext.placeholder = Constants.string.lastName.localize()
        navigationItem.title = Constants.string.signUpNavTitle.localize()
        self.textFieldPassword.placeholder = Constants.string.password.localize()
        self.textFieldPhoneNumber.placeholder = Constants.string.phoneNumber.localize()
        self.fieldConfirmPassword.placeholder = Constants.string.ConfirmPassword.localize()
    }
    
    private func addGustureforNextBtn(){
        
        let nextBtnGusture = UITapGestureRecognizer(target: self, action: #selector(nextIconTapped(sender:)))
        self.nextView.addGestureRecognizer(nextBtnGusture)
    }
    
    
    private func setCommonFont(){
        //MARK:- setCommonFont For textFields
//        for i in 0 ... self.view.subviews.count - 1 {
//            if (self.view.subviews[i].isKind(of: TextField.self)) {
//                var textField = HoshiTextField()
//                textField = self.view.subviews[i] as! HoshiTextField
//                setFont(TextField: textField, label: nil, Button: nil, size: nil)
//
//                textField.borderActiveColor = .primary
//                textField.borderInactiveColor = .lightGray
//                textField.placeholderColor = .gray
//                textField.textColor = .black
//                textField.delegate = self
//
//            }
//        }
        for i in 0 ... textFieldCollection.count-1 {
//            textFieldCollection[i].borderActiveColor = .primary
//            textFieldCollection[i].borderInactiveColor = UIColor.lightGray
//            textFieldCollection[i].placeholderColor = UIColor.gray
            textFieldCollection[i].textColor = UIColor.black
            textFieldCollection[i].delegate = self
            textFieldCollection[i].textAlignment = .left
            if textFieldCollection[i] == fieldConfirmPassword {
                print("Confirm password")
            }
            setFont(TextField: textFieldCollection[i], label: nil, Button: nil, size: nil)
        }
        
        textFieldPhoneNumber.delegate = self
        textFieldPassword.delegate = self

    }
    
    
    func unsetSelection(){
        self.tableView.allowsSelection = false
    }
  
    
  
    
    @objc private func nextIconTapped(sender: UITapGestureRecognizer){
      
        guard let email = validateField(EmailTxt.text, with: EmailValidator()) else {
            EmailTxt.shake()
            return
        }

        guard let firstName = self.FirstName.text, !firstName.isEmpty else {
            vibrate(sound: .cancelled)
            FirstName.shake()
             UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterFirstName.localize())
            return
        }
        
        guard let lastName = self.lastNametext.text, !lastName.isEmpty else {
            vibrate(sound: .cancelled)
            lastNametext.shake()
             UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterLastName.localize())
            return
        }
        
        guard let phoneNumber = validateField(textFieldPhoneNumber.text, with: PhoneValidator()) else {
            textFieldPhoneNumber.shake()
            return
        }
        
        guard let password = validateField(textFieldPassword.text, with: PasswordValidator()) else {
            textFieldPassword.shake()
            return
        }
        
        guard let confirmPassword = validateField(fieldConfirmPassword.text, with: PasswordValidator()) else {
            fieldConfirmPassword.shake()
            return
        }
        
        guard password == confirmPassword else {
            UIApplication.shared.keyWindow?.make(toast: SignUp.ErrorMessage.passwordsDoNotMatch)
            return
        }
        
        let akPhone = AKFPhoneNumber(countryCode: "in", phoneNumber: phoneNumber)
        let accountKitVC = accountKit.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
        accountKitVC.enableSendToFacebook = true
        self.prepareLogin(viewcontroller: accountKitVC)
        self.present(accountKitVC, animated: true, completion: nil)
        
        userSignUpInfo = MakeJson.SingUp(firstName: firstName, lastName: lastName, email: email, mobile: Int(phoneNumber) ?? 0, password: password, ConfirmPassword: confirmPassword, device_Id: deviceId, device_type: DeviceType.ios.rawValue , device_token: deviceTokenString)
    }
    
    
    private func changeNextButtonFrame() {
        
        UIApplication.shared.keyWindow?.addSubview(self.nextView)
        let frameWidth : CGFloat = 50 * (UIScreen.main.bounds.width/375)
        self.nextView.translatesAutoresizingMaskIntoConstraints = false
        self.nextView.heightAnchor.constraint(equalToConstant: frameWidth).isActive = true
        self.nextView.widthAnchor.constraint(equalToConstant: frameWidth).isActive = true
        self.nextView.bottomAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.bottomAnchor, constant: -16).isActive = true
        self.nextView.trailingAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.trailingAnchor, constant: -16).isActive = true

        
//        let frameWidth : CGFloat = 50 * (UIScreen.main.bounds.width/375)
//        self.nextView.makeRoundedCorner()
//        self.nextView.frame = CGRect(x: UIScreen.main.bounds.width-(frameWidth+16), y: UIScreen.main.bounds.height-(frameWidth+16), width: frameWidth, height: frameWidth)
//        self.nextImage.frame = CGRect(x: self.nextView.frame.width/4, y: self.nextView.frame.height/4, width: self.nextView.frame.width/2, height: self.nextView.frame.height/2)
        // self.nextImage.frame = CGRect(x: nextView.frame.midX, y: nextView.frame.midY, width: self.nextView.frame.width/2, height: self.nextView.frame.height/2)
        
    }
    
    
    func SetNavigationcontroller(){
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            //Fallback on earlier versions
        }
        title = "Enter the details you used to register"
        
        // self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(SignUpTableViewController.backBarButton(sender:)))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(nextIconTapped(sender:)))
        
        //self.navigationController?.view.addSubview(nextView)
        
    }
    
    @IBAction private func savebuttontapped(sender: UIBarButtonItem){
        
    }
    
    @IBAction private func backBarButton(sender: UIButton){
        self.popOrDismiss(animation: true)
    }
    
    private func validateField(_ field: String?, with validator: Validator) -> String? {
        do {
            let field = try FieldValidator(validator: validator).validate(field).resolve()
            return field
        } catch let error as ValidationError {
            vibrate(sound: .cancelled)
            showToast(string: error.errorMessage)
            return nil
        } catch {
            return nil
        }
    }
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
}


extension SignUpTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        EmailTxt.placeholder = Constants.string.email.localize()
        FirstName.placeholder = Constants.string.firsrName.localize()
        lastNametext.placeholder = Constants.string.lastName.localize()
//        if textField == textFieldPhoneNumber {
//            let accountKit = AKFAccountKit(responseType: .accessToken)
//            //let akPhone = AKFPhoneNumber(countryCode: "in", phoneNumber: )
//            let accountKitViewController = accountKit.viewControllerForPhoneLogin()
//            accountKitViewController.enableSendToFacebook = true
//            self.prepareLogin(viewcontroller: accountKitViewController)
//            self.present(accountKitViewController, animated: true, completion: nil)
//        }
    
        (textField as? HoshiTextField)?.borderActiveColor = UIColor.primary
    }
    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
        viewcontroller.uiManager.theme?()?.buttonTextColor = .white
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            EmailTxt.placeholder = Constants.string.email.localize()
            FirstName.placeholder = Constants.string.firsrName.localize()
            lastNametext.placeholder = Constants.string.lastName.localize()
        }
        (textField as? HoshiTextField)?.borderInactiveColor = UIColor.lightGray
        
        if textField == EmailTxt {
            if textField.text?.count == 0 {
                textField.placeholder = Constants.string.emailPlaceHolder.localize()
            } else if let email = validateField(EmailTxt.text, with: EmailValidator()) {
                textField.resignFirstResponder()
                let user = User()
                user.email = email
                presenter?.post(api: .providerVerify, data: user.toData())
            }
        }
        
    }
    

    
   
    

    
}

extension SignUpTableViewController : AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {        
        func dismiss () {
            viewController.dismiss(animated: true)
            self.loader.isHidden = false
            self.presenter?.post(api: .signUp, data: self.userSignUpInfo?.toData())
        }
        
        accountKit.requestAccount { (account, error) in
            
            self.phoneNumber = account?.phoneNumber?.stringRepresentation() ?? ""
            
            if let phoneNumber = account?.phoneNumber {
                var mobileString = phoneNumber.stringRepresentation()
                if mobileString.hasPrefix("+") {
                    mobileString.removeFirst()
                    self.userSignUpInfo?.mobile = mobileString
                    }
                }
            dismiss()
           
        }
        
    }
}


extension SignUpTableViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        if api == .providerVerify {
            self.EmailTxt.shake()
            vibrate(sound: .tryAgain)
            DispatchQueue.main.async {
                self.EmailTxt.becomeFirstResponder()
            }
        }
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.showToast(string: message)
        }
    }
    
    func getAuth(api: Base, data: UserData?) {
        
        if data?.access_token != nil{
            User.main.accessToken = data?.access_token
            //UserDefaults.standard.set(data?.access_token, forKey: "access_token")
            storeInUserDefaults()
            self.presenter?.get(api: .getProfile, parameters: nil)
           // self.presenter?.post(api: .login, data: MakeJson.login(email: (userSignUpInfo?.email)!, password: (userSignUpInfo?.password)!, deviceId: deviceId, deviceType: DeviceType.ios.rawValue, deviceToken: deviceTokenString))
        }
        
        
    }
    
   /* func getLogin(api: Base, data: LoginModel?) {
        if data?.access_token !=  nil {
            self.loader.isHidden = true
            UserDefaults.standard.set(data?.access_token, forKey: "access_token")
            User.main.accessToken = data?.access_token
            storeInUserDefaults()
            if data?.access_token !=  nil {
                //self.loader.isHidden = true
                
                self.presenter?.get(api: .getProfile, parameters: nil)
                
            }else {
                
            }
            
        }else {
            
        }
        
        //        let user = User()
        //        user.accessToken = data?.access_token
        
    } */
    
    func getProfile(api: Base, data: Profile?) {
        
        Common.storeUserData(from: data)
        storeInUserDefaults()
        DispatchQueue.main.async {
            self.loader.isHidden = true
            toastSuccess(UIApplication.shared.keyWindow! , message: Constants.string.signUpSucess as NSString, smallFont: true, isPhoneX: true, color: UIColor.primary)
            NotificationCenter.default.post(name: .OnboardingDidComplete, object: self)
        }
        
    }
    
}

