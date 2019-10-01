//
//  invoiceView.swift
//  User
//
//  Created by CSS on 15/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class invoiceView: UIView {
    
    //MAREK:- UIlabel outlets
    @IBOutlet var viewInvoiceTitle: UILabel!
    @IBOutlet var labelBookinID: UILabel!
    @IBOutlet var labelBookingIDValue: UILabel!
    @IBOutlet var labelTotal: UILabel!
    @IBOutlet var labeltotalValue: UILabel!
    @IBOutlet var labelTotalToBePaid: UILabel!
    @IBOutlet var labelAmountTobePaid: UILabel!
    @IBOutlet var labelCash: UILabel!
    
    @IBOutlet private weak var viewTips : UIView!
    @IBOutlet private weak var labelTipsString : UILabel!
    @IBOutlet private weak var labelTips : UILabel!
    
    //MARK:- outlets for image view
    @IBOutlet var imageMoney: UIImageView!
    @IBOutlet var viewVisualEffect: UIVisualEffectView!
    
    //MARK:- outlets for Button
    @IBOutlet var buttonConfirm: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewTips.isHidden = true
        self.localize()
        setCommonFont()
        if BackGroundTask.backGroundInstance.detailviewStatus == true {
            buttonConfirm.setTitle(Constants.string.Done.localize(), for: .normal)
        }else {
            
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
       
    }
    
    func setCommonFont(){
        
        setFont(TextField: nil, label: labelCash, Button: nil, size: nil)
        setFont(TextField: nil, label: labelTotal, Button: nil, size: nil)
        setFont(TextField: nil, label: labelBookinID, Button: nil, size: nil)
        setFont(TextField: nil, label: labelCash, Button: nil, size: nil)
        setFont(TextField: nil, label: labeltotalValue, Button: nil, size: nil)
        setFont(TextField: nil, label: labelBookingIDValue, Button: nil, size: nil)
        setFont(TextField: nil, label: labelAmountTobePaid, Button: nil, size: nil)
        setFont(TextField: nil, label: labelTotalToBePaid, Button: buttonConfirm, size: nil)
        setFont(TextField: nil, label: nil, Button: buttonConfirm, size: nil)
        setFont(TextField: nil, label: labelTips, Button: nil, size: nil)
        setFont(TextField: nil, label: labelTipsString, Button: nil, size: nil)
    }
    
    // MARK:- Localize
    private func localize() {
        self.viewInvoiceTitle.text = Constants.string.invoice.localize()
        self.labelTipsString.text = Constants.string.tips.localize()
        self.labelBookinID.text = Constants.string.bookingId.localize()
        self.labelTotal.text = Constants.string.total.localize()
        self.labelTotalToBePaid.text = Constants.string.amountToBePaid.localize()
       // buttonConfirm.setTitle(Constants.string.confirmPayment.localize(), for: .normal)
    }
    
    
    
    func set(request: YourTripModelResponse){
        
        self.labelBookingIDValue.text = request.booking_id
        self.labeltotalValue.text = "\(User.main.currency ?? "$") \(Formatter.shared.limit(string: "\(request.payment?.total ?? 0)", maximumDecimal: 2))"
        self.labelAmountTobePaid.text = "\(User.main.currency ?? "$") \(Formatter.shared.limit(string: "\(request.payment?.payable ?? 0)", maximumDecimal: 2))"
        self.labelCash.text = request.payment_mode?.lowercased().localize().uppercased()
        self.imageMoney.image = request.payment_mode == PaymentType.CARD.rawValue ? UIImage(named: "visa") : UIImage(named: "money")
        self.viewTips.isHidden = Float.removeNil(request.payment?.tips) == 0
        self.labelTips.text = "\(User.main.currency ?? "$") \(Formatter.shared.limit(string: "\(request.payment?.tips ?? 0)", maximumDecimal: 2))"
    }
 

}
