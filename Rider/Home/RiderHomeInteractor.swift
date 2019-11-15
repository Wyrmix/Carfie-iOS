//
//  RiderHomeInteractor.swift
//  Rider
//
//  Created by Christopher Olsen on 11/15/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class RiderHomeInteractor {
    weak var viewController: HomeViewController?
    
    func changeCard() {
        let listPaymentViewController = ListPaymentViewController.viewController(for: .rider, and: self)
        let navigationController = UINavigationController(rootViewController: listPaymentViewController)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss(_:)))
        listPaymentViewController.navigationItem.setRightBarButton(cancelButton, animated: false)
        viewController?.present(navigationController, animated: true)
    }
    
    @objc private func dismiss(_ selector: Any?) {
        viewController?.dismiss(animated: true)
    }
}

// MARK: - ListPaymentDelegate
extension RiderHomeInteractor: ListPaymentDelegate {
    func paymentSelected(_ payment: CarfieCard) {
        let cardEntity = CardEntity(payment)
        viewController?.presentChangedCard(cardEntity)
        viewController?.dismiss(animated: true)
    }
    
    func paymentDeleted(_ payment: CarfieCard) {
        
    }
}

// MARK: - RequestSelectionViewDelegate
extension RiderHomeInteractor: RequestSelectionViewDelegate {
    func paymentChangeRequested() {
        changeCard()
    }
    
    func requestRide(from service: Service?, with payment: CardEntity?, of type: PaymentType) {
        guard let service = service else {
            UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: viewController)
            return
        }
        
        viewController?.createRequest(for: service, isScheduled: false, scheduleDate: nil, cardEntity: payment, paymentType: type)
    }
    
    func scheduleRide(for service: Service?, with payment: CardEntity?, of type: PaymentType) {
        guard let service = service else {
            UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: viewController)
            return
        }
        
        viewController?.schedulePickerView { [weak self] date in
            guard let self = self else { return }
            self.viewController?.createRequest(
                for: service,
                isScheduled: true,
                scheduleDate: date,
                cardEntity: payment,
                paymentType: type
            )
        }
    }
}
