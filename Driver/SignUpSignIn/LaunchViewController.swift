//
//  LaunchViewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit


class LaunchViewController: UIViewController {
    
    
    @IBOutlet private var buttonSignIn : UIButton!
    @IBOutlet private var buttonSignUp : UIButton!
    @IBOutlet private var buttonSocialLogin : UIButton!
    
    //private weak var viewWalkThrough : WalkThroughView?
    
    
    
    var presenter: PostPresenterInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.buttonAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}


//MARK:- Methods

extension LaunchViewController {
    
    //MARK:- Initial Loads
    
    private func initialLoads(){
        
        self.setLocalization()
       // self.setDesigns()
        setCommonFont()
         User.main.loginType = LoginType.manual.rawValue // Set default login as manual
    }
    
    
    //MARK:-Set Font Family
    private func setDesigns(){
        
        buttonSignIn.titleLabel?.font = UIFont(name: FontCustom.medium.rawValue, size: 16)
        buttonSignUp.titleLabel?.font = UIFont(name: FontCustom.medium.rawValue, size: 16)
        buttonSignIn.setTitleColor(.white, for: .normal)
        buttonSignUp.setTitleColor(.white, for: .normal)
        
    }
    
    private func setCommonFont(){
        setFont(TextField: nil, label: nil, Button: nil, size: nil)
        setFont(TextField: nil, label: nil, Button: nil, size: nil)
        setFont(TextField: nil, label: nil, Button: buttonSignIn, size: nil, with : true)
        setFont(TextField: nil, label: nil, Button: buttonSignUp, size: nil, with : true)
        setFont(TextField: nil, label: nil, Button: buttonSocialLogin, size: nil, with : true)
        buttonSignIn.setTitleColor(.white, for: .normal)
        buttonSignUp.setTitleColor(.white, for: .normal)
    }
    
    private func buttonAction(){
        buttonSignIn.addTarget(self, action: #selector(signInBtnTapped(Sender:)), for: .touchUpInside)
        buttonSignUp.addTarget(self, action: #selector(signUpBtnTapped(sender:)), for: .touchUpInside)
        buttonSocialLogin.addTarget(self, action: #selector(socialLoginbuttonTapped(button:)), for: .touchUpInside)
        
    }
    
    @IBAction private func socialLoginbuttonTapped(button: UIButton){
        self.push(id: Storyboard.Ids.SocialLoginViewController, animation: true, from: Router.user)
    }
    
    @objc private func signInBtnTapped(Sender: UIButton){
        push(id: Storyboard.Ids
            .EmailViewController, animation: true, from: Router.user)
    }
    @objc private func signUpBtnTapped(sender:UIButton){
        push(id: Storyboard.Ids.SignUpViewController, animation: true, from: Router.user)
    }
    
    @objc private func socialBtnLogin(sender: UIButton){
        push(id: Storyboard.Ids.SocialLoginViewController, animation: true, from: Router.user)
    }
    
    //MARK:- Method Localize Strings
    
    private func setLocalization(){
        
        buttonSignUp.setTitle(Constants.string.signUp.localize(), for: .normal)
        buttonSignIn.setTitle(Constants.string.signIn.localize(), for: .normal)
        buttonSocialLogin.setTitle(Constants.string.orConnectWithSocial.localize(), for: .normal)
        
    }
    
    
    //MARK:- UIButton Actions
    
    
    
}

extension LaunchViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
    }
    
}


extension LaunchViewController : UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
}


