//
//  InvoiceView.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class InvoiceView: UIView {

    @IBOutlet private weak var labelBookingString : UILabel!
    @IBOutlet private weak var labelBooking : UILabel!
    @IBOutlet private weak var labelDistanceTravelledString : UILabel!
    @IBOutlet private weak var labelDistanceTravelled : UILabel!
    @IBOutlet private weak var labelTimeTakenString : UILabel!
    @IBOutlet private weak var labelTimeTaken : UILabel!
    @IBOutlet private weak var labelTax : UILabel!
    @IBOutlet private weak var labelTaxString : UILabel!
    @IBOutlet private weak var labelTipsString : UILabel!
    @IBOutlet private weak var buttonTips : UIButton!
    @IBOutlet private weak var labelTotalString : UILabel!
    @IBOutlet private weak var labelTotal : UILabel!
    @IBOutlet private weak var labelWalletString : UILabel!
    @IBOutlet private weak var labelWallet : UILabel!
    @IBOutlet private weak var labelDiscountString : UILabel!
    @IBOutlet private weak var labelDiscount : UILabel!
    @IBOutlet private weak var labelToPayString : UILabel!
    @IBOutlet private weak var labelToPay : UILabel!
    @IBOutlet private weak var labelPaymentType : Label!
    @IBOutlet private weak var buttonChangePayment : UIButton!
    @IBOutlet private weak var buttonPayNow : UIButton!
    @IBOutlet private weak var labelTitle : UILabel!
    
    @IBOutlet private weak var viewTax : UIView!
    @IBOutlet private weak var viewWallet : UIView!
    @IBOutlet private weak var viewDiscount : UIView!
    @IBOutlet private weak var viewDistance: UIView!
    @IBOutlet private weak var viewTips : UIView!
    
    private var viewTipsXib : ViewTips?
    private var paymentType : PaymentType = .NONE { // Check Payment Type
        didSet {
            if paymentType != oldValue {
                let paymentString = paymentType == .CASH ? PaymentType.CASH.rawValue.localize() : (self.selectedCard?.last_four==nil) ? PaymentType.CARD.rawValue.localize() : "XXXX-\(String.removeNil(self.selectedCard?.last_four))"
                let text = "\(Constants.string.payment.localize()):\(paymentString)"
                self.labelPaymentType.text = text
                self.labelPaymentType.attributeColor = .secondary
                self.labelPaymentType.startLocation = ((text.count)-(paymentType.rawValue.localize().count))
                self.labelPaymentType.length = paymentType.rawValue.localize().count
                if (User.main.isCardAllowed == false){
                    self.buttonChangePayment.isHidden = true
                }else {
                    self.buttonChangePayment.isHidden = (isShowingRecipt && User.main.isCardAllowed)
                }
                self.viewTips.isHidden = !(self.paymentType == .CARD || isShowingRecipt)
                self.viewTips.isUserInteractionEnabled = !isShowingRecipt // Disable userInteraction to Tips if from Past trips
            }
        }
    }
    
    private var couponId : String? = nil {
        didSet {
            
        }
    }
    
    private var serviceCalculator : ServiceCalculator = .NONE
    
    private var isUsingWallet = false {
        didSet {
             self.viewWallet.isHidden = !isUsingWallet
        }
    }
    
    private var isDiscountApplied = false {
        didSet {
           self.viewDiscount.isHidden = !self.isDiscountApplied
        }
    }
    
    private var tipsAmount : Float = 0 {
        didSet {
           self.updatePayment()
        }
    }
    
    var onClickPaynow : ((Float)->Void)?
    var onDoneClick : ((Bool)->Void)?
    var onClickChangePayment : ((_ completion : @escaping ((CardEntity)->()))->Void)?
    var selectedCard : CardEntity?
    var isShowingRecipt = false
    private var requestId = 0
    private var total : Float = 0 {
        didSet{
            self.updatePayment()
        }
    }
    private var payyable : Float = 0 {
        didSet{
            self.updatePayment()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.intialLoads()
    }
}

// MARK:- Methods

extension InvoiceView {
    
    func intialLoads() {
        self.buttonPayNow.addTarget(self, action: #selector(self.buttonPaynowAction), for: .touchUpInside)
        self.buttonChangePayment.addTarget(self, action: #selector(self.buttonChangePaymentAction), for: .touchUpInside)
        self.buttonTips.addTarget(self, action: #selector(self.buttonTipsAction(sender:)), for: .touchUpInside)
        self.tipsAmount = 0
        self.localize()
        self.setDesign()
        self.viewDistance.isHidden = true 
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: labelTitle, isTitle: true)
        Common.setFont(to: buttonPayNow, isTitle: true)
        Common.setFont(to: labelTotal, isTitle: true, size: 20)
        Common.setFont(to: labelTotalString, isTitle: true, size: 20)
        Common.setFont(to: labelToPay, isTitle: true, size: 20)
        Common.setFont(to: labelToPayString, isTitle: true, size: 20)
        Common.setFont(to: labelDiscount)
        Common.setFont(to: labelDiscountString)
        Common.setFont(to: labelBooking)
        Common.setFont(to: labelBookingString)
        Common.setFont(to: labelTimeTaken)
        Common.setFont(to: labelTimeTakenString)
        Common.setFont(to: labelDistanceTravelled)
        Common.setFont(to: labelDistanceTravelledString)
        Common.setFont(to: labelTax)
        Common.setFont(to: labelTaxString)
        Common.setFont(to: labelTipsString)
        Common.setFont(to: labelWallet)
        Common.setFont(to: labelWalletString)
        Common.setFont(to: labelPaymentType)
        Common.setFont(to: buttonChangePayment)
    }
    
    
    
    // MARK:- Localize
    
    private func localize() {
        
        self.labelBookingString.text = Constants.string.bookingId.localize()
        self.labelDistanceTravelledString.text = Constants.string.distanceTravelled.localize()
        self.labelTimeTakenString.text = Constants.string.timeTaken.localize()
        self.labelTaxString.text = Constants.string.tax.localize()
        self.labelTipsString.text = Constants.string.tips.localize()
        self.buttonTips.setTitle(Constants.string.addTips.localize(), for: .normal)
        self.labelTotalString.text = Constants.string.total.localize()
        self.labelWalletString.text = Constants.string.walletDeduction.localize()
        self.labelDiscountString.text = Constants.string.discount.localize()
        self.labelTitle.text = Constants.string.invoice.localize()
        
    }
    
    func set(request : Request) {
        if (isShowingRecipt || request.paid == 1) {
            self.buttonPayNow.setTitle(Constants.string.Done.localize(), for: .normal)
        }else{
            self.buttonPayNow.setTitle(Constants.string.paynow.localize(), for: .normal)
        }
//        self.buttonPayNow.setTitle((isShowingRecipt ? Constants.string.Done : ).localize(), for: .normal)
        self.labelToPayString.text = (isShowingRecipt ? Constants.string.paid : Constants.string.toPay).localize()
        self.labelBooking.text = request.booking_id
        
        //if Int(request.distanceInt!) > 0 {
            self.labelDistanceTravelled.text = "\(Formatter.shared.limit(string: "\(request.distanceInt ?? 0)", maximumDecimal: 1)) \(String.removeNil(request.unit))"
        
        
        self.labelTimeTaken.text = "\(String.removeNil(request.travel_time)) \(Constants.string.mins.localize())"
        self.paymentType = request.payment_mode ?? .NONE
        self.serviceCalculator = request.service?.calculator ?? .NONE
        self.isUsingWallet = (request.payment?.wallet ?? 0)>0
        self.isDiscountApplied = (request.payment?.discount ?? 0)>0
        // Set Amount to Label
        func setAmount(to label : UILabel, with amount : Float?) {
            label.text = "\(String.removeNil(User.main.currency)) \(Formatter.shared.limit(string: "\(Float.removeNil(amount))", maximumDecimal: 2))"
        }
        
        setAmount(to: self.labelTax, with: request.payment?.tax)
        setAmount(to: self.labelWallet, with: request.payment?.wallet)
        setAmount(to: self.labelDiscount, with: request.payment?.discount)
        self.total = request.payment?.total ?? 0
        if self.tipsAmount == 0 {
            self.tipsAmount = request.payment?.tips ?? 0
        }
        if self.isShowingRecipt { // On recipt page
            self.payyable = self.total-((request.payment?.discount ?? 0)+(request.payment?.wallet ?? 0))
        } else { // On Invoice page
            self.payyable = request.payment?.payable ?? 0
        }
        if (request.payment_mode == .CASH && !isShowingRecipt) && (request.paid == 0){
            self.labelPaymentType.isHidden = false
            self.buttonPayNow.isHidden = true
        }else{
            self.buttonPayNow.isHidden = false
        }
        if (request.paid == 1){
            self.labelPaymentType.isHidden = true
            self.buttonChangePayment.isHidden = true
            self.buttonPayNow.isHidden = false
        }
        
        
//        self.buttonPayNow.isHidden = (request.payment_mode == .CASH && !isShowingRecipt)
    }
    
    private func updatePayment() {
        self.buttonTips.setTitle((tipsAmount>0 || self.isShowingRecipt) ? " \(String.removeNil(User.main.currency)) \(Formatter.shared.limit(string: "\(tipsAmount)", maximumDecimal: 2)) " : " \(Constants.string.addTips.localize()) ", for: .normal)
        self.labelTotal.text = "\(String.removeNil(User.main.currency)) \(Formatter.shared.limit(string: "\(tipsAmount+total)", maximumDecimal: 2))"
        self.labelToPay.text = "\(String.removeNil(User.main.currency)) \(Formatter.shared.limit(string: "\(tipsAmount+payyable)", maximumDecimal: 2))"
    }
    
    @IBAction private func buttonPaynowAction() {
        if buttonPayNow.titleLabel?.text == Constants.string.Done{
            self.onDoneClick?(true)
        }else{
            self.onClickPaynow?(self.tipsAmount)
        }
    }
    
    // MARK:- Change Payment Type
    @IBAction private func buttonChangePaymentAction() {
        self.onClickChangePayment?({ [weak self] card in
            self?.selectedCard = card
        })
    }
    
    
    @IBAction private func buttonTipsAction(sender : UIButton){
        
        if self.viewTipsXib == nil {
            self.viewTipsXib = ViewTips(frame: .zero)
            self.viewTipsXib?.alpha = 0
            self.viewTipsXib?.backgroundColor = .white
            self.viewTipsXib?.addBackgroundView(in: self, gesture: UITapGestureRecognizer(target: self, action: #selector(self.dismissTipsView)))
            self.addSubview(self.viewTipsXib!)
            UIView.animate(withDuration: 0.5) {
                self.viewTipsXib?.alpha = 1
            }
            self.viewTipsXib?.translatesAutoresizingMaskIntoConstraints = false
            self.viewTipsXib?.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0 ).isActive = true
            self.viewTipsXib?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0 ).isActive = true
            self.viewTipsXib?.heightAnchor.constraint(equalToConstant: 150).isActive = true
            self.viewTipsXib?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
            self.viewTipsXib?.tipsAmount = tipsAmount
            self.viewTipsXib?.onClickSubmit = { value in
                self.tipsAmount = value
                self.dismissTipsView()
            }
        }
        self.viewTipsXib?.total = self.total
    }
    
    @IBAction private func dismissTipsView() {
        self.removeBackgroundView()
        UIView.animate(withDuration: 0.5, animations: {
            self.viewTipsXib?.alpha = 0
        }) { (_) in
            self.viewTipsXib?.removeFromSuperview()
            self.viewTipsXib = nil
        }
    }
    
}
