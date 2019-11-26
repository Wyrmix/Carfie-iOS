//
//  RequestSelectionView.swift
//  User
//
//  Created by CSS on 19/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

protocol RequestSelectionViewDelegate: class {
    func paymentChangeRequested()
    func requestRide(from service: Service?, with payment: CardEntity?, of type: PaymentType)
    func scheduleRide(for service: Service?, with payment: CardEntity?, of type: PaymentType)
}

class RequestSelectionView: UIView {
    
   
    @IBOutlet private weak var labelUseWalletString : UILabel!
    @IBOutlet private weak var imageViewWallet : UIImageView!
    @IBOutlet private weak var buttonScheduleRide : UIButton!
    @IBOutlet private weak var buttonRideNow : UIButton!
    @IBOutlet private weak var viewUseWallet : UIView!
    @IBOutlet private weak var labelEstimationFareString : UILabel!
    @IBOutlet private weak var labelEstimationFare : UILabel!
    @IBOutlet private weak var labelCouponString : UILabel!
    @IBOutlet private weak var labelPaymentMode : Label!
    @IBOutlet private weak var buttonChangePayment : UIButton!
    @IBOutlet private weak var buttonCoupon : UIButton!
    @IBOutlet private weak var imageViewModal : UIImageView!
    @IBOutlet private weak var viewImageModalBg : UIView!
    @IBOutlet private weak var labelWalletBalance : UILabel!
    
    weak var delegate: RequestSelectionViewDelegate?
    
    var onclickCoupon : ((_ couponList : [PromocodeEntity],_ selected : PromocodeEntity?, _ promo : ((PromocodeEntity?)->())?)->Void)?
    var selectedCoupon : PromocodeEntity? { // Selected Promocode
        didSet{
            if let percentage = selectedCoupon?.percentage, let maxAmount = selectedCoupon?.max_amount, let fare = self.service?.pricing?.estimated_fare{
                
                let discount = fare*(percentage/100)
                let discountAmount = discount > maxAmount ? maxAmount : discount
                self.setEstimationFare(amount: fare-discountAmount)
                
            } else {
                self.setEstimationFare(amount: self.service?.pricing?.estimated_fare)
            }
        }
    }
    
    private var availablePromocodes = [PromocodeEntity]() { // Entire Promocodes available for selection
        didSet {
            self.isPromocodeEnabled = availablePromocodes.count>0
        }
    }
    
    private var isWalletChecked = false {  // Handle Wallet
        didSet {
            self.imageViewWallet.image = isWalletChecked ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check-box-empty")
            self.service?.pricing?.useWallet = isWalletChecked ? 1 : 0
        }
    }
    
    var selectedCard: CardEntity?
    var paymentType: PaymentType = .NONE {
        didSet {
            var paymentText: String
            
            switch paymentType {
            case .NONE:
                paymentText = "None selected"
            case .CARD:
                if let lastFour = selectedCard?.last_four {
                    paymentText = "XXXX-\(lastFour)"
                } else {
                    paymentText = "None selected"
                }
            case .CASH:
                // TECH-DEBT: remmove CASH option completely.
                // This should no longer be allowed.
                paymentText = "None selected"
            }

            let text = "Payment: \(paymentText)"
            labelPaymentMode.text = text
            labelPaymentMode.startLocation = (text.count) - (paymentText.count)
            labelPaymentMode.length = paymentText.count
        }
    }
    
    private var isPromocodeEnabled = false {
        didSet {
            self.buttonCoupon.setTitle({
                if !isPromocodeEnabled {
                    return " None "
                }else {
                    return self.selectedCoupon != nil ? " \(String.removeNil(self.selectedCoupon?.promo_code)) " : " \(Constants.string.viewCoupons.localize()) "
                }
            }(), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.buttonCoupon.layoutIfNeeded()
            }
            self.buttonCoupon.isEnabled = isPromocodeEnabled
        }
    }
    
    private var service : Service?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewImageModalBg.makeRoundedCorner()
    }
    
    private func setup() {
        labelPaymentMode.attributeColor = AppTheme.rider.tintColor
        buttonCoupon.backgroundColor = AppTheme.rider.primaryButtonColor
    }
}

// MARK:- Methods

extension RequestSelectionView {
    
    // MARK:- Initial Loads
    
    private func initialLoads() {
        self.backgroundColor = .clear
        self.isWalletChecked = false
        self.localize()
        self.setDesign()
        self.viewUseWallet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.useWalletAction)))
        self.paymentType = .NONE
        if (User.main.isCardAllowed == false){
            self.buttonChangePayment.isHidden = true
        } else {
            self.buttonChangePayment.isHidden = !User.main.isCardAllowed
        }
        self.buttonChangePayment.addTarget(self, action: #selector(self.buttonChangePaymentAction), for: .touchUpInside)
        self.buttonCoupon.addTarget(self, action: #selector(self.buttonCouponAction), for: .touchUpInside)
        self.isPromocodeEnabled = false
        self.presenter?.get(api: .promocodes, parameters: nil)
    }
    
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: buttonRideNow, isTitle: true)
        Common.setFont(to: buttonScheduleRide, isTitle:  true)
        Common.setFont(to: labelUseWalletString)
        Common.setFont(to: labelEstimationFareString, isTitle: true)
        Common.setFont(to: labelEstimationFare, isTitle: true)
        Common.setFont(to: labelCouponString)
        Common.setFont(to: labelPaymentMode)
        Common.setFont(to: buttonChangePayment)
        Common.setFont(to: buttonCoupon)
        Common.setFont(to: labelWalletBalance, isTitle: true)
        
    }
    
    
    // MARK:- Localize
    
    private func localize() {
        
        self.labelUseWalletString.text = Constants.string.useWalletAmount.localize()
        self.buttonScheduleRide.setTitle(Constants.string.scheduleRide.localize().uppercased(), for: .normal)
        self.buttonRideNow.setTitle(Constants.string.rideNow.localize().uppercased(), for: .normal)
        self.labelEstimationFareString.text = Constants.string.estimatedFare.localize()
        self.labelCouponString.text = Constants.string.coupon.localize()
        self.buttonChangePayment.setTitle(Constants.string.change.localize().uppercased(), for: .normal)
    }
    
    
    func setValues(values : Service) {
        self.service = values
        self.viewUseWallet.isHidden = !(Float.removeNil(self.service?.pricing?.wallet_balance)>0)
        self.setEstimationFare(amount: self.service?.pricing?.estimated_fare)
        self.paymentType = User.main.isCashAllowed ? .CASH :( User.main.isCardAllowed ? .CARD : .NONE)
        self.imageViewModal.setImage(with: values.image, placeHolder: #imageLiteral(resourceName: "CarplaceHolder"))
        self.labelWalletBalance.text = "\(String.removeNil(User.main.currency)) \(Formatter.shared.limit(string: "\(Float.removeNil(self.service?.pricing?.wallet_balance))", maximumDecimal: 2))"
    }
    
    func setEstimationFare(amount : Float?) {
        self.labelEstimationFare.text = "\(User.main.currency ?? .Empty) \(Formatter.shared.limit(string: "\(amount ?? 0)", maximumDecimal: 2))"
    }
    
    @IBAction private func buttonScheduleAction(){
        self.service?.promocode = self.selectedCoupon
        delegate?.scheduleRide(for: service, with: selectedCard, of: paymentType)
    }
    
    @IBAction private func buttonRideNowAction(){
        self.service?.promocode = self.selectedCoupon
        delegate?.requestRide(from: service, with: selectedCard, of: paymentType)
    }
    
    @IBAction private func useWalletAction(){
        self.isWalletChecked = !isWalletChecked
        
    }
    @IBAction private func buttonCouponAction() {
        self.onclickCoupon?( self.availablePromocodes,self.selectedCoupon, { [weak self] selectedCouponCode in  // send Available couponlist and get the selected coupon entity
            self?.selectedCoupon = selectedCouponCode
            self?.isPromocodeEnabled = true
            })
    }
    @IBAction private func buttonChangePaymentAction() {
        delegate?.paymentChangeRequested()
    }
}

// MARK:- PostViewProtocol

extension RequestSelectionView : RiderPostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getPromocodeList(api: Base, data: [PromocodeEntity]) {
        self.availablePromocodes = data
    }
}

// MARK: - Presenters
extension RequestSelectionView {
    func configure(with viewModel: RideRequestViewModel) {
        selectedCard = viewModel.card
        paymentType = viewModel.paymentType
    }
}
