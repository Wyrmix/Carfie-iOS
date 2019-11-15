//
//  DriverHomeIntercator.swift
//  Driver
//
//  Created by Christopher Olsen on 11/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DriverHomeInteractor {
    
    weak var viewController: HomepageViewController?
    
    func showAddDocuments() {
        guard viewController?.presentedViewController == nil else { return }
        viewController?.present(DocumentsViewController.viewController(), animated: true)
    }
    
    func showAddPayment() {
        guard viewController?.presentedViewController == nil else { return }
        let paymentViewController = AddPaymentViewController.viewController(for: .driver, and: self)
        
        // We want to force the driver to add a payment method here, so prevent dismissal by any means.
        if #available(iOS 13, *) {
            paymentViewController.isModalInPresentation = true
        }
        
        viewController?.present(paymentViewController, animated: true)
    }
}

extension DriverHomeInteractor: AddCardDelegate {
    func cardAdded() {
        viewController?.dismiss(animated: true)
    }
    
    func requestDismissal() {
        viewController?.logout()
    }
}
