//
//  ForgotPasswordViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet private var viewNext: UIView!
    @IBOutlet private var textFieldEmail : HoshiTextField!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    var emailString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.viewScroll.frame.height)
    }
    
}

//MARK:- Methods

extension ForgotPasswordViewController {
    
    private func initialLoads(){
        
        self.setDesigns()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.scrollView.addSubview(viewScroll)
        self.textFieldEmail.text = emailString
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    
    private func setDesigns(){
        
        self.textFieldEmail.borderActiveColor = .primary
        self.textFieldEmail.borderInactiveColor = .lightGray
        self.textFieldEmail.placeholderColor = .gray
        self.textFieldEmail.textColor = .black
        self.textFieldEmail.delegate = self
        Common.setFont(to: textFieldEmail)
    }
    
    
    private func localize(){
        
        self.textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        self.navigationItem.title = Constants.string.enterYourMailIdForrecovery.localize()
    }
    
    
    //MARK:- Next View Tap Action
    
    @IBAction private func nextAction(){
        viewNext.addPressAnimation()

        do {
            let email = try EmailValidator().validate(textFieldEmail.text).resolve()
            let userData = UserData()
            userData.email = email
            loader.isHidden = false
            presenter?.post(api: .forgotPassword, data: userData.toData())
        } catch let error as ValidationError {
            view.make(toast: error.errorMessage) { [weak self] in
                self?.textFieldEmail.becomeFirstResponder()
            }
        } catch {
            textFieldEmail.becomeFirstResponder()
        }
    }
}

extension ForgotPasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textFieldEmail.placeholder = Constants.string.email.localize()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        }
    }
    
}

//MARK:- PostViewProtocol

extension ForgotPasswordViewController : RiderPostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.view.make(toast: message)
            self.loader.isHidden = true
        }
    }
    
    func getUserData(api: Base, data: UserDataResponse?) {
        
        if data != nil {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChangeResetPasswordController) as? ChangeResetPasswordController {
                vc.set(user: data!)
                vc.isChangePassword = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        self.loader.isHideInMainThread(true)
    }
    
}

//// MARK:- UIScrollViewDelegate
//
//extension ForgotPasswordViewController : UIScrollViewDelegate {
//
////    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        if #available(iOS 11.0, *) {
////            let offset = scrollView.contentOffset
////            self.scrollView.contentOffset = offset
////        }
////    }
//}
