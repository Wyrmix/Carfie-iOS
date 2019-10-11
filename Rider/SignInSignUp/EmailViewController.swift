//
//  EmailViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet private var viewNext: UIView!
    @IBOutlet private var textFieldEmail : HoshiTextField!
    @IBOutlet private var buttonCreateAcount : UIButton!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!
    
    var isHideLeftBarButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = self.viewScroll.bounds.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
       // self.textFieldEmail.becomeFirstResponder()
    }

}

//MARK:- Methods

extension EmailViewController {

    
    private func initialLoads(){
       
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setDesigns()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
        if !isHideLeftBarButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        }
        self.scrollView.addSubview(viewScroll)
        self.buttonCreateAcount.addTarget(self, action: #selector(self.createAccountAction), for: .touchUpInside)
        self.scrollView.contentOffset = .zero
    }
    
    
    private func setDesigns(){
        
        self.textFieldEmail.borderActiveColor = .primary
        self.textFieldEmail.borderInactiveColor = .lightGray
        self.textFieldEmail.placeholderColor = .gray
        self.textFieldEmail.textColor = .black
        self.textFieldEmail.delegate = self
        Common.setFont(to: textFieldEmail)
        Common.setFont(to: buttonCreateAcount)
        
    }
    
    
    private func localize() {
        
        self.textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        let attr :[NSAttributedString.Key : Any]  = [.font : UIFont.systemFont(ofSize: 14)]
        self.buttonCreateAcount.setAttributedTitle(NSAttributedString(string: Constants.string.iNeedTocreateAnAccount.localize(), attributes: attr), for: .normal)
        self.navigationItem.title = Constants.string.whatsYourEmailAddress.localize()
        
    }
    
    
    //MARK:- Next View Tap Action
    
    @IBAction private func nextAction(){
        viewNext.addPressAnimation()
        
        do {
            let email = try EmailValidator().validate(textFieldEmail.text).resolve()
            presentPasswordViewController(withEmail: email)
        } catch let error as ValidationError {
            view.make(toast: error.errorMessage) { [weak self] in
                self?.textFieldEmail.becomeFirstResponder()
            }
        } catch {
            textFieldEmail.becomeFirstResponder()
        }
    }
    
    private func presentPasswordViewController(withEmail email: String) {
        guard let passwordVC = storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.PasswordViewController) as? PasswordViewController else { return }
        passwordVC.set(email: email)
        navigationController?.pushViewController(passwordVC, animated: true)
    }
    
    //MARK:- Create Account
    
    @IBAction private func createAccountAction(){
        
        self.push(id: Storyboard.Ids.SignUpTableViewController, animation: true)
        
    }
    
    
    
}

extension EmailViewController : UITextFieldDelegate {
    
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

