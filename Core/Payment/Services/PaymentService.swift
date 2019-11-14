//
//  PaymentService.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/8/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol PaymentService {
    func getCards(theme: AppTheme, completion: @escaping (Result<GetCardsResponse>) -> Void)
    func addCard(_ cardToken: CarfieCardToken, theme: AppTheme, completion: @escaping (Result<AddCardResponse>) -> Void)
}

class StripePaymentService: PaymentService {
    private let service: NetworkService
    
    init(service: NetworkService = DefaultNetworkService()) {
        self.service = service
    }
    
    func getCards(theme: AppTheme, completion: @escaping (Result<GetCardsResponse>) -> Void) {
        let request = GetCardsRequest(theme: theme)
        service.request(request) { result in
            completion(result)
        }
    }
    
    func addCard(_ cardToken: CarfieCardToken, theme: AppTheme, completion: @escaping (Result<AddCardResponse>) -> Void) {
        let request = AddCardRequest(theme: theme, cardToken: cardToken)
        service.request(request) { result in
            completion(result)
        }
    }
}
