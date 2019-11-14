//
//  PaymentController.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/8/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation
import Stripe

enum PaymentControllerError: Error {
    case invalidToken
}

protocol PaymentController {
    func getCards(theme: AppTheme, completion: @escaping (Result<GetCardsResponse>) -> Void)
    func addCard(_ card: STPCardParams, theme: AppTheme, completion: @escaping (Result<AddCardResponse>) -> Void)
}

final class StripePaymentController: PaymentController {
    
    private let paymentService: PaymentService
    
    init(paymentService: PaymentService = StripePaymentService()) {
        self.paymentService = paymentService
    }
    
    func getCards(theme: AppTheme, completion: @escaping (Result<GetCardsResponse>) -> Void) {
        paymentService.getCards(theme: theme) { result in
            completion(result)
        }
    }
    
    func addCard(_ card: STPCardParams, theme: AppTheme, completion: @escaping (Result<AddCardResponse>) -> Void) {
        STPAPIClient.shared().createToken(withCard: card) { (token, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let token = token?.tokenId else {
                completion(.failure(PaymentControllerError.invalidToken))
                return
            }
            
            let card = CarfieCardToken(stripeToken: token)
            
            // No weak self because we want this to complete even if the user moves away before
            // this request completes.
            self.paymentService.addCard(card, theme: theme) { result in
                completion(result)
            }
        }
    }
}
