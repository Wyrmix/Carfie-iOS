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
    @IBOutlet private var buttonSocialLogin : UIButton!
    
    var presenter: RiderPostPresenterInputProtocol?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}


//MARK:- Methods

extension LaunchViewController {
    
    //MARK:- Initial Loads
    
    private func initialLoads(){
      
        self.setLocalization()
        self.setDesigns()
        self.buttonSignIn.addTarget(self, action: #selector(self.buttonSignInAction), for: .touchUpInside)
        self.buttonSocialLogin.addTarget(self, action: #selector(self.buttonSocialLoginAction), for: .touchUpInside)
        User.main.loginType = LoginType.manual.rawValue // Set default login as manual
    }
    
    
    //MARK:-Set Font Family
    private func setDesigns(){
       Common.setFont(to: self.buttonSignIn, isTitle: true)
       Common.setFont(to: self.buttonSocialLogin)
       buttonSignIn.setTitleColor(.white, for: .normal)
    }
    
    //MARK:- Method Localize Strings
    
    private func setLocalization(){
       buttonSignIn.setTitle(Constants.string.signIn.localize(), for: .normal)
       buttonSocialLogin.setTitle(Constants.string.orConnectWithSocial.localize(), for: .normal)
    }
    
    
    @IBAction private func buttonSignInAction(){

        self.push(id: Storyboard.Ids.EmailViewController, animation: true)
        
    }
    
    @IBAction private func buttonSocialLoginAction(){
        
        self.push(id: Storyboard.Ids.SocialLoginViewController, animation: true)
        
    }
    
  
}

extension LaunchViewController : RiderPostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
    }
    
}


extension LaunchViewController : UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
}


