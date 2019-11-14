//
//  ListPaymentInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/13/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class ListPaymentInteractor {
    
    weak var viewController: ListPaymentViewController?
    
    private var viewModel: ListPaymentViewModel
    
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
                let paymentItems = response.cardList.map({ PaymentTableViewCellViewModel(lastFourCardDigits: $0.lastFour) })
                self.viewModel.paymentItems = paymentItems
                self.viewController?.presentPaymentItems(self.viewModel.paymentItems)
            } catch {
                UserFacingErrorIntent(title: "Something went wrong", message: "There was a problem retrieving your payment methods.").execute(via: self.viewController)
            }
        }
    }
    
    func askToDeletePaymentMethod(indexPath: IndexPath) {
        guard viewModel.paymentItems.count >= indexPath.row else {
            assertionFailure("Array index out of bounds.")
            return
        }
        
        UserFacingDestructiveErrorIntent(
            title: "Are you sure you want to delete this card?",
            message: viewModel.paymentItems[indexPath.row].text,
            destructiveTitle: "Delete",
            destructiveAction: { _ in
                self.deletePaymentMethod()
        }).execute(via: viewController)
    }
    
    private func deletePaymentMethod() {
        
    }
    
    func addPaymentMethod() {
        let addPaymentViewController = AddPaymentViewController.viewController(for: theme)
        viewController?.present(addPaymentViewController, animated: true)
    }
}
