//
//  PaymentService.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/8/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol PaymentService {
    func addCard(_ card: CarfieCard, theme: AppTheme, completion: @escaping (Result<AddCardResponse>) -> Void)
}

class StripePaymentService: PaymentService {
    private let service: NetworkService
    
    init(service: NetworkService = DefaultNetworkService()) {
        self.service = service
    }
    
    func addCard(_ card: CarfieCard, theme: AppTheme, completion: @escaping (Result<AddCardResponse>) -> Void) {
        let request = AddCardRequest(theme: theme, card: card)
        service.request(request) { result in
            completion(result)
        }
    }
}
