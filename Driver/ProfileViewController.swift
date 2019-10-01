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
    
//    private var tripType :TripType = .Business { // Store Radio option TripType
//
//        didSet {
//
//            self.imageViewBusiness.image = tripType == .Business ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
//            self.imageViewPersonal.image = tripType == .Personal ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
//
//        }
//
//    }
    
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
        self.initialLoads()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

// MARK:- Methods

extension ProfileViewController {
    
    private func initialLoads() {
        
        self.viewPersonal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setTripTypeAction(sender:))))
        self.viewBusiness.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setTripTypeAction(sender:))))
        self.viewImageChange.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeImage)))
        self.buttonSave.addTarget(self, action: #selector(self.buttonSaveAction), for: .touchUpInside)
        self.buttonChangePassword.addTarget(self, action: #selector(self.changePasswordAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.profile.localize()
        getProfile()
        self.localize()
        self.setDesign()
        self.setProfile()
        self.view.dismissKeyBoardonTap()
        
        self.buttonChangePassword.isHidden = (User.main.loginType != LoginType.manual.rawValue)
    }
    
    private func getProfile(){
        
        self.presenter?.get(api: .getProfile, parameters: nil)
        
    }
    
    // MARK:- Set Profile Details
    
    private func setProfile(){
        
        
//        let url = (User.main.picture?.contains(WebConstants.string.http) ?? false) ? User.main.picture : Common.getImageUrl(for: User.main.picture)
//        
//        Cache.image(forUrl: url) { (image) in
//            DispatchQueue.main.async {
//                self.imageViewProfile.image = image == nil ? #imageLiteral(resourceName: "userPlaceholder") : image
//            }
//        }
        
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
    
    @IBAction private func setTripTypeAction(sender : UITapGestureRecognizer) {
        
//        guard let senderView = sender.view else { return }
//
//        self.tripType = senderView == viewPersonal ? .Personal : .Business
//
    }
    
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
        
        guard let mobile = self.textFieldPhone.text, mobile.count>0 else {
            vibrate(sound: .cancelled)
            textFieldPhone.shake()
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterPhoneNumber.localize())
            return
        }
        
        guard let email = self.textFieldEmail.text, email.count>0 else {
            vibrate(sound: .cancelled)
            textFieldEmail.shake()
            
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterEmail.localize())
            return
        }
        
        guard Common.isValid(email: email) else {
            vibrate(sound: .cancelled)
            textFieldEmail.shake()
            UIScreen.main.focusedView?.make(toast: ErrorMessage.list.enterValidEmail.localize())
            return
        }
        
        
        
        if self.changedImage != nil, let dataImg = self.changedImage?.pngData() {
            data = dataImg
        }
        
//        let akPhone = AKFPhoneNumber(countryCode: "in", phoneNumber: mobile)
//        let accountKitVC = accountKit.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
//        accountKitVC.enableSendToFacebook = true
//        self.prepareLogin(viewcontroller: accountKitVC)
//        self.present(accountKitVC, animated: true, completion: nil)
//
        
       
        servicemodel.service = User.main.serviceId
        
        profile.device_token = deviceTokenString
        profile.email = email
        profile.first_name = firstName
        profile.last_name = lastName
        profile.mobile = mobile
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
        //self.labelTripType.text = Constants.string.tripType.localize()
        //self.labelBusiness.text = Constants.string.business.localize()
        //self.labelPersonal.text = Constants.string.personal.localize()
        self.buttonChangePassword.setTitle(Constants.string.lookingToChangePassword.localize(), for: .normal)
        
    }
    
    //MARK:- Button Change Password Action
    
    @IBAction private func changePasswordAction() {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChangeResetPasswordController) as? ChangeResetPasswordController {
            vc.isChangePassword = true
            self.navigationController?.pushViewController(vc, animated: true)
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
        
        print(scrollView.contentOffset)
        
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
        //print("service ID:\(data?.avatar)")
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

        }else{
            Common.storeUserData(from: data)
            storeInUserDefaults()
            DispatchQueue.main.async {
                self.loader.isHidden = true
                self.setProfile()
            }

        }
        
    }
}
