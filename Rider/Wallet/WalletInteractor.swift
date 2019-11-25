//
//  WalletInteractor.swift
//  Rider
//
//  Created by Christopher Olsen on 11/14/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class WalletInteractor {
    weak var viewController: WalletViewController?
    
    var viewState: WalletViewState
    
    private let paymentController: PaymentController
    
    init(paymentController: PaymentController = StripePaymentController()) {
        self.paymentController = paymentController
        self.viewState = WalletViewState()
    }
    
    func start() {
        getCards()
        getWalletDefaults()
    }
    
    func getWalletDefaults() {
        viewController?.presentWalletDefaults(viewState.walletDefaultValues)
    }
    
    func getWalletDefaultForButton(index: Int) {
        viewController?.presentAddToWalletValue(viewState.walletDefaultValues[index])
    }
    
    func getCards() {
        paymentController.getCards(theme: .rider) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let cards = try result.resolve()
                guard let card = cards.first else {
                    self.viewController?.setCard(nil)
                    self.addCard()
                    return
                }
                self.viewController?.setCard(CardEntity(card))
            } catch {
                UserFacingErrorIntent(
                    title: "Something went wrong",
                    message: "There was a problem retrieving your payment methods."
                ).execute(via: self.viewController)
            }
        }
    }
    
    func changeCard() {
        let listPaymentViewController = ListPaymentViewController.viewController(for: .rider, and: self)
        let navigationController = UINavigationController(rootViewController: listPaymentViewController)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss(_:)))
        listPaymentViewController.navigationItem.setRightBarButton(cancelButton, animated: false)
        viewController?.present(navigationController, animated: true)
    }
    
    func addCard() {
        UserFacingErrorIntent(
            title: "No payment methods",
            message: "Add a payment method to use your wallet.",
            wihCancelActionAnd: { action in
                let addPaymentViewController = AddPaymentViewController.viewController(for: .rider, and: self)
                self.viewController?.present(addPaymentViewController, animated: true)
            }
        ).execute(via: viewController)
    }
    
    @objc private func dismiss(_ selector: Any?) {
        viewController?.dismiss(animated: true)
    }
}

// MARK: - ListPaymentDelegate
extension WalletInteractor: ListPaymentDelegate {
    func paymentSelected(_ payment: CarfieCard) {
        let cardEntity = CardEntity(payment)
        viewController?.setCard(cardEntity)
        viewController?.dismiss(animated: true)
    }
    
    func paymentAdded() {}
    
    func paymentDeleted(_ payment: CarfieCard) {
        getCards()
    }
}

// MARK: - AddCardDelegate
extension WalletInteractor: AddCardDelegate {
    func cardAdded() {
        getCards()
        viewController?.dismiss(animated: true)
    }
    
    func requestDismissal() {
        viewController?.dismiss(animated: true)
    }
}
