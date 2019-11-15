//
//  ListPaymentInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/13/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol ListPaymentDelegate: class {
    func paymentSelected(_ payment: CarfieCard)
    func paymentDeleted(_ payment: CarfieCard)
}

class ListPaymentInteractor {
    
    weak var viewController: ListPaymentViewController?
    weak var delegate: ListPaymentDelegate?
    
    private var viewModel: ListPaymentViewModel
    
    private var cards: [CarfieCard]?
    
    private let theme: AppTheme
    private let paymentController: PaymentController
    
    init(theme: AppTheme, paymentController: PaymentController = StripePaymentController()) {
        self.theme = theme
        self.paymentController = paymentController
        self.viewModel = ListPaymentViewModel()
    }
    
    func getPaymentMethods() {
        paymentController.getCards(theme: theme) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let response = try result.resolve()
                self.cards = response
                let paymentItems = response.map({ PaymentTableViewCellViewModel(lastFourCardDigits: $0.lastFour) })
                self.viewModel.paymentItems = paymentItems
                self.viewController?.presentPaymentItems(self.viewModel.paymentItems)
            } catch {
                UserFacingErrorIntent(
                    title: "Something went wrong",
                    message: "There was a problem retrieving your payment methods."
                ).execute(via: self.viewController)
            }
        }
    }
    
    func askToDeletePaymentMethod(indexPath: IndexPath, with completion: @escaping (Bool) -> Void) {
        guard viewModel.paymentItems.count >= indexPath.row else {
            assertionFailure("Array index out of bounds.")
            return
        }
        
        UserFacingDestructiveErrorIntent(
            title: "Are you sure you want to delete this card?",
            message: viewModel.paymentItems[indexPath.row].text,
            destructiveTitle: "Delete",
            action: { _ in
                completion(false)
            },
            destructiveAction: { _ in
                self.deletePaymentMethod(indexPath.row)
        }).execute(via: viewController)
    }
    
    private func deletePaymentMethod(_ index: Int) {
        guard let cardToDelete = cards?[index] else { return }
        
        // TODO: Animate row removal
        // optimistically remove card from the view
        viewModel.paymentItems.remove(at: index)
        viewController?.presentPaymentItems(self.viewModel.paymentItems)
        
        paymentController.deleteCard(cardToDelete, theme: theme) { [weak self] result in
            switch result {
            case .success:
                self?.getPaymentMethods()
                self?.delegate?.paymentDeleted(cardToDelete)
            case .failure:
                UserFacingErrorIntent(
                    title: "Something went wrong",
                    message: "There was a problem deleting your payment method. Please try again"
                ).execute(via: self?.viewController)
            }
        }
    }
    
    func addPaymentMethod() {
        let addPaymentViewController = AddPaymentViewController.viewController(for: theme, and: self)
        viewController?.present(addPaymentViewController, animated: true)
    }
    
    func selectPaymentMethod(_ index: Int) {
        guard let card = cards?[index] else { return }
        delegate?.paymentSelected(card)
    }
}

extension ListPaymentInteractor: AddCardDelegate {
    func cardAdded() {
        getPaymentMethods()
        viewController?.dismiss(animated: true)
    }
    
    func requestDismissal() {
        viewController?.dismiss(animated: true)
    }
}
