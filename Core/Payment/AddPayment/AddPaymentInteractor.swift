//
//  AddPaymentInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/6/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation
import Stripe

protocol AddCardDelegate: class {
    func cardAdded()
}

class AddPaymentInteractor {
    
    weak var viewController: AddPaymentViewController?
    weak var delegate: AddCardDelegate?
    
    private let theme: AppTheme
    private let paymentController: PaymentController
    
    init(theme: AppTheme, paymentController: PaymentController = StripePaymentController()) {
        self.theme = theme
        self.paymentController = paymentController
    }
    
    func addPayment(_ cardParameters: STPCardParams) {
        viewController?.animateSaveButton(true)
        paymentController.addCard(cardParameters, theme: theme) { [weak self] result in
            self?.viewController?.animateSaveButton(false)
            
            switch result {
            case .success:
                self?.delegate?.cardAdded()
                self?.viewController?.dismiss(animated: true)
            case .failure:
                UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: self?.viewController)
            }
        }
    }
    
    func dismiss() {
        // check for lock
        viewController?.dismiss(animated: true)
    }
}
