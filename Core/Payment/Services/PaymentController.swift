//
//  PaymentController.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/8/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation
import Stripe

enum StripeCurrency: String {
    case usDollars = "usd"
}

enum PaymentControllerError: Error {
    case invalidToken
    case notADebitCard
}

protocol PaymentController {
    func getCards(theme: AppTheme, completion: @escaping (Result<GetCardsResponse>) -> Void)
    func addCard(_ card: STPCardParams, theme: AppTheme, completion: @escaping (Result<AddCardResponse>) -> Void)
    func deleteCard(_ card: CarfieCard, theme: AppTheme, completion: @escaping (Result<DeleteCardResponse>) -> Void)
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
        if theme == .driver {
            // This is necessary for the driver because they must use a debit card which requires currency type to be set
            card.currency = StripeCurrency.usDollars.rawValue
        }
        
        STPAPIClient.shared().createToken(withCard: card) { (token, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let token = token else {
                completion(.failure(PaymentControllerError.invalidToken))
                return
            }
            
            // Drivers can only use debit cards.
            if theme == .driver {
                guard token.card?.funding == STPCardFundingType.debit else {
                    completion(.failure(PaymentControllerError.notADebitCard))
                    return
                }
            }
            
            let card = CarfieCardToken(stripeToken: token.tokenId)
            
            // No weak self because we want this to complete even if the user moves away before
            // this request completes.
            self.paymentService.addCard(card, theme: theme) { result in
                completion(result)
            }
        }
    }
    
    func deleteCard(_ card: CarfieCard, theme: AppTheme, completion: @escaping (Result<DeleteCardResponse>) -> Void) {
        paymentService.deleteCard(card, theme: theme) { result in
            completion(result)
        }
    }
}
