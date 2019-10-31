//
//  Profile.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Foundation

struct CarfieProfile: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let mobile: String
    let avatar: String?
    let deviceToken: String?
    let accessToken: String?
    let currency: String
    let service: CarfieService?
    var walletBalance: Float?
    var measurement: String?
    var card: Int?
    var cash: Int?
    var stripeSecretKey: String?
    var stripePublishableKey: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case mobile
        case avatar
        case deviceToken = "device_token"
        case accessToken = "access_token"
        case currency
        case service
        case walletBalance = "wallet_balance"
        case measurement
        case card
        case cash
        case stripeSecretKey = "stripe_secret_key"
        case stripePublishableKey = "stripe_publishable_key"
    }
}

struct CarfieService: Codable {
    let service: Int?
    let providerId: Int?
    let serviceType: CarfieServiceType?
    
    enum CodingKeys: String, CodingKey {
        case service
        case providerId = "provider_id"
        case serviceType = "service_type"
    }
}

struct CarfieServiceType: Codable {
    let name: String?
    let id: Int?
}
