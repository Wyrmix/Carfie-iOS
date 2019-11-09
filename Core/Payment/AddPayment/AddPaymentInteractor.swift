//
//  AddPaymentInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/6/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation
import Stripe

class AddPaymentInteractor {
    
    weak var viewController: AddPaymentViewController?
    
    private let theme: AppTheme
    private let paymentController: PaymentController
    
    init(theme: AppTheme, paymentController: PaymentController = StripePaymentController()) {
        self.theme = theme
        self.paymentController = paymentController
    }
    
    func addPayment(_ cardParameters: STPCardParams) {
        paymentController.addCard(cardParameters, theme: theme) { [weak self] result in

        }
    }
}
