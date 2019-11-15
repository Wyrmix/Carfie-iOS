//
//  WalletViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var labelBalance : Label!
    @IBOutlet private weak var textFieldAmount : UITextField!
    @IBOutlet private weak var viewWallet : UIView!
    @IBOutlet private weak var buttonAddAmount : UIButton!
    @IBOutlet var labelWallet: UILabel!
    @IBOutlet var labelAddMoney: UILabel!
    @IBOutlet private var buttonsAmount : [UIButton]!
    @IBOutlet private weak var viewCard : UIView!
    @IBOutlet private weak var labelCard: UILabel!
    @IBOutlet private weak var buttonChange : UIButton!
    
    private var selectedCardEntity : CardEntity?
    
    private var interactor: WalletInteractor?
    
    private var isWalletEnabled : Bool = false {
        didSet{
            self.buttonAddAmount.isEnabled = isWalletEnabled
            self.buttonAddAmount.backgroundColor = isWalletEnabled ? .primary : .lightGray
            self.viewCard.isHidden = !isWalletEnabled
        }
    }
    
    private var isWalletAvailable : Bool = false {
        didSet {
            self.buttonAddAmount.isHidden = !isWalletAvailable
            self.viewCard.alpha = CGFloat(isWalletAvailable ? 1 : 0)
            self.viewWallet.alpha = CGFloat(isWalletAvailable ? 1 : 0)
        }
    }
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor = WalletInteractor()
        interactor?.viewController = self
        interactor?.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.isWalletAvailable = User.main.isCardAllowed
        self.initalLoads()
    }
}

extension WalletViewController {
    
    private func initalLoads() {
        self.setWalletBalance()
        self.presenter?.get(api: .getProfile, parameters: nil)
        self.view.dismissKeyBoardonTap()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.wallet.localize()
        self.setDesign()
        self.textFieldAmount.placeholder = String.removeNil(User.main.currency)+" "+"\(0)"
        self.textFieldAmount.delegate = self
        for (index,button) in buttonsAmount.enumerated() {
            button.tag = (index*100)+99
            button.setTitle(String.removeNil(String.removeNil(User.main.currency)+" \(button.tag)"), for: .normal)
        }
        self.buttonChange.addTarget(self, action: #selector(self.buttonChangeCardAction), for: .touchUpInside)
        self.isWalletEnabled = false
        KeyboardAvoiding.avoidingView = self.view
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: labelBalance, isTitle: true)
        Common.setFont(to: textFieldAmount)
        Common.setFont(to: labelCard)
        Common.setFont(to: buttonChange)
        buttonChange.setTitle(Constants.string.change.localize(), for: .normal)
        labelAddMoney.text = Constants.string.addAmount.localize()
        labelWallet.text = Constants.string.yourWalletAmnt.localize()
        buttonAddAmount.setTitle(Constants.string.ADDAMT, for: .normal)
        
    }
    
    @IBAction private func buttonAmountAction(sender : UIButton) {
        
        textFieldAmount.text = "\(sender.tag)"
    }
    
    func setCard(_ card: CardEntity?) {
        selectedCardEntity = card
        
        guard let card = card else {
            isWalletEnabled = false
            labelCard.text = nil
            return
        }
        
        isWalletEnabled = true
        if let lastFour = card.last_four {
           labelCard.text = "XXXX-XXXX-XXXX-\(lastFour)"
        }
    }
    
    
    @IBAction private func buttonAddAmountClick() {
        self.view.endEditingForce()
        guard let text = textFieldAmount.text?.replacingOccurrences(of: String.removeNil(User.main.currency), with: "").removingWhitespaces(),  text.isNumber, Int(text)! > 0  else {
            self.view.make(toast: Constants.string.enterValidAmount.localize())
            return
        }
        guard self.selectedCardEntity != nil else{
            return
        }
        self.loader.isHidden = false
        let cardId = self.selectedCardEntity?.card_id
        self.selectedCardEntity?.strCardID = cardId
        self.selectedCardEntity?.amount = text
        self.presenter?.post(api: Base.addMoney, data: self.selectedCardEntity?.toData())
    }
    
    // MARK:- Change Card Action
    
    @IBAction private func buttonChangeCardAction() {
        interactor?.changeCard()
    }
    
    
    private func setWalletBalance() {
        DispatchQueue.main.async {
            self.labelBalance.text = String.removeNil(User.main.currency)+" \(User.main.wallet_balance ?? 0)"
        }
    }
    
    
}


extension WalletViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     //   print(IQKeyboardManager.sharedManager().keyboardDistanceFromTextField)
    }
}

// MARK:- PostViewProtocol

extension WalletViewController : RiderPostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        Common.storeUserData(from: data)
        storeInUserDefaults()
        self.setWalletBalance() 
    }
   
    func getWalletEntity(api: Base, data: WalletEntity?) {
        User.main.wallet_balance = data?.balance
        storeInUserDefaults()
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.setWalletBalance()
            self.textFieldAmount.text = nil
            UIApplication.shared.keyWindow?.makeToast(data?.message)
        }
    }
    
}
