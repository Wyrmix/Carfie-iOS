//
//  PasswordViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    @IBOutlet private var viewNext : UIView!
    @IBOutlet private var textFieldPassword : HoshiTextField!
    @IBOutlet private var buttonForgotPassword : UIButton!
    @IBOutlet private var buttonCreateAccount : UIButton!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!

    private var email : String?
    
 
    
    private lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialLoads()
       // self.textFieldPassword.text = "qwerty"
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setCommonFont()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setFrame()
    }
    
    

}


//MARK:- Methods

extension PasswordViewController {
    private func setCommonFont(){
        
        setFont(TextField: textFieldPassword, label: nil, Button: buttonCreateAccount, size: nil)
        setFont(TextField: nil, label: nil, Button: buttonForgotPassword, size: nil)
    }

    private func initialLoads(){
        
        self.setDesigns()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        if #available(iOS 11.0, *) {
            //self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .never
        }
        self.scrollView.addSubview(viewScroll)
        self.setFrame()
        self.buttonCreateAccount.addTarget(self, action: #selector(self.createAccountAction), for: .touchUpInside)
        self.buttonForgotPassword.addTarget(self, action: #selector(self.forgotPasswordAction), for: .touchUpInside)
//        self.textFieldPassword.setPasswordView()
        
    }
    
    private func setFrame(){
        
        self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = self.viewScroll.bounds.size
       // self.scrollView.contentOffset = .zero
    }
    
    private func setDesigns() {
        
        self.textFieldPassword.borderActiveColor = .primary
        self.textFieldPassword.borderInactiveColor = .lightGray
        self.textFieldPassword.placeholderColor = .gray
        self.textFieldPassword.textColor = .black
        self.textFieldPassword.delegate = self
        self.textFieldPassword.font = UIFont(name: FontCustom.medium.rawValue, size: 2)
        
    }
    
    private func localize() {
        
        self.textFieldPassword.placeholder = Constants.string.enterPassword.localize()
        self.buttonCreateAccount.setAttributedTitle(NSAttributedString(string: Constants.string.iNeedTocreateAnAccount.localize(), attributes: [.font : UIFont(name: FontCustom.medium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)]), for: .normal)
        self.buttonForgotPassword.setAttributedTitle(NSAttributedString(string: Constants.string.iForgotPassword.localize(), attributes: [.font : UIFont(name: FontCustom.medium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)]), for: .normal)
        self.navigationItem.title = Constants.string.welcomeBackPassword.localize()
    }
    
    
    //MARK:- Set Values
    
    func set(email : String?) {
        
        self.email = email
        
    }
    
    
    //MARK:- Next View Tap Action
    
    @IBAction private func nextAction() {
        
        self.viewNext.addPressAnimation()
        
        if email == nil { //Go back if Email is nil
            
            self.popOrDismiss(animation: true)
        }
        
        guard  let passwordText = self.textFieldPassword.text, !passwordText.isEmpty else {
            vibrate(sound: .cancelled)
            textFieldPassword.shake()
            self.view.make(toast: ErrorMessage.list.enterPassword) {
                self.textFieldPassword.becomeFirstResponder()
            }
            
            return
        }
//        self.push(id: Storyboard.Ids.HomepageViewController, animation: true)
        self.loader.isHidden = false
        self.presenter?.post(api: .login, data: MakeJson.login(email: email!, password: passwordText, deviceId: deviceId, deviceType: DeviceType.ios.rawValue, deviceToken: deviceTokenString))

    }
    
    //MARK:- Create Account

    @IBAction private func createAccountAction() {
        
        self.push(id: Storyboard.Ids.SignUpViewController, animation: true, from: Router.user)

        
    }
    
    //MARK:- Forgot Password
    @IBAction private func forgotPasswordAction() {
        
        
       // self.push(id: Storyboard.Ids.ForgotPasswordViewController, animation: true, from: Router.user)
        if let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ForgotPasswordViewController) as? ForgotPasswordViewController {
            forgotVC.emailString = email
            self.navigationController?.pushViewController(forgotVC, animated: true)
        }
    }

}


extension PasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textFieldPassword.placeholder = Constants.string.password.localize()
        (textField as! HoshiTextField).borderActiveColor = UIColor.primary
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textFieldPassword.placeholder = Constants.string.enterPassword.localize()
        }
        (textField as! HoshiTextField).borderInactiveColor = UIColor.lightGray
    }
    
}

extension PasswordViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        self.loader.isHidden = true
        DispatchQueue.main.async {
            self.present(showAlert(message: message), animated: true, completion: nil)
        }
        
    }
    
    func getLogin(api: Base, data: LoginModel?) {
        print("login sucess: \(String(describing: data?.access_token))")
        //UserDefaults.standard.set(data?.access_token, forKey: "access_token")
        User.main.accessToken = data?.access_token
        storeInUserDefaults()
        
        if data?.access_token !=  nil {
            //self.loader.isHidden = true
            self.presenter?.get(api: .getProfile, parameters: nil)
        }
        
//        let user = User()
//        user.accessToken = data?.access_token
       
    }
    func getProfile(api: Base, data: Profile?) {
      //  print("service ID:\(data?.service?.service_type?.id)")
        Common.storeUserData(from: data)
        storeInUserDefaults()
        DispatchQueue.main.async {
            self.loader.isHidden = true
            toastSuccess(UIApplication.shared.keyWindow! , message: Constants.string.loginSucess as NSString, smallFont: true, isPhoneX: true, color: UIColor.primary)
            self.present(Common.setDrawerController(), animated: true, completion: nil)
            
        }
        
    }
 
    
    
}
