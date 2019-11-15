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
    
    /// Called when a new card is added .
    func cardAdded()
    
    /// Called when the user attempts to dismiss the add payment screen. This is necessary for the driver app to
    /// force the drvier to add a card before they begin driving.
    func requestDismissal()
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
    
    func start() {
        switch theme {
        case .driver:
            viewController?.updateDescriptionLabelText("""
                                                       Before you can start driving we need a way to pay you!
                                                       You must add a valid debit card.
                                                       """)
        case .rider:
            // currently we don't add any context for the user as they have no restrictions on card type.
            viewController?.updateDescriptionLabelText("")
        }
    }
    
    func addPayment(_ cardParameters: STPCardParams) {
        viewController?.animateSaveButton(true)
        paymentController.addCard(cardParameters, theme: theme) { [weak self] result in
            self?.viewController?.animateSaveButton(false)
            
            do {
                _ = try result.resolve()
                self?.delegate?.cardAdded()
            } catch PaymentControllerError.notADebitCard {
                UserFacingErrorIntent(
                    title: "Must use a debit card",
                    message: "The card you entered is not a valid debit card. You need to use a debit card to receive payment."
                ).execute(via: self?.viewController)
            } catch {
                UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: self?.viewController)
            }
        }
    }
    
    func dismiss() {
        guard let delegate = delegate else {
            viewController?.dismiss(animated: true)
            return
        }
        
        delegate.requestDismissal()
    }
}
