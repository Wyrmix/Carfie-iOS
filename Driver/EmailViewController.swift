//
//  EmailViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet private var viewNext: UIView!
    @IBOutlet private var textFieldEmail : HoshiTextField!
    @IBOutlet private var buttonCreateAcount : UIButton!
    //@IBOutlet var textFieldEmail: ShakingTextField!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!
    
    var isHideLeftBarButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
       //self.textFieldEmail.text = "sdk+driver1@gmail.com"
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = self.viewScroll.bounds.size
    }

}

//MARK:- Methods

extension EmailViewController {

    
    private func initialLoads(){
        
        
        self.setCommonFont()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.navigationController?.isNavigationBarHidden = false
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
       // self.SetNavigationcontroller()
        if !isHideLeftBarButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        }
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.scrollView.addSubview(viewScroll)
        self.buttonCreateAcount.addTarget(self, action: #selector(self.createAccountAction), for: .touchUpInside)

   }
    func SetNavigationcontroller(){
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = "Enter the details"
    
        // self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(SignUpTableViewController.backBarButton(_:)))
    }
    
    @IBAction func backBarButton(sender:UIButton){
        
    }
    

    
    private func setDesigns(){
        
        self.textFieldEmail.borderActiveColor = .primary
        self.textFieldEmail.borderInactiveColor = .lightGray
        self.textFieldEmail.placeholderColor = .gray
        self.textFieldEmail.textColor = .black
        self.textFieldEmail.delegate = self
       // self.textFieldEmail.font = UIFont(name: FontCustom.clanPro_Book.rawValue, size: 2)
        
    }
    
    private func setCommonFont(){
        
        setFont(TextField: textFieldEmail, label: nil, Button: buttonCreateAcount, size: nil)
        setFont(TextField: nil, label: nil, Button: buttonCreateAcount, size: nil)
        
    }
    
    
    private func localize() {
        self.textFieldEmail.placeholder = Constants.string.email.localize()
        let attr :[NSAttributedString.Key : Any]  = [.font : UIFont(name: FontCustom.medium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)]
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
            vibrate(sound: .cancelled)
            self.textFieldEmail.shake()
            view.make(toast: error.errorMessage) { [weak self] in
                self?.textFieldEmail.becomeFirstResponder()
            }
        } catch {
            vibrate(sound: .cancelled)
            self.textFieldEmail.shake()
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
        
       self.push(id: Storyboard.Ids.SignUpViewController, animation: true, from: Router.user)
    }
    
}

extension EmailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textFieldEmail.placeholder = Constants.string.email.localize()
        
        (textField as! HoshiTextField).borderActiveColor = UIColor.primary
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        }
        (textField as! HoshiTextField).borderInactiveColor = UIColor.lightGray
    }
    
}

//extension HoshiTextField {
//
//    func shake () {
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 0.05
//        animation.repeatCount = 5
//        animation.autoreverses = true
//        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
//        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
//        self.layer.add(animation, forKey: "position")
//
//    }
//}


