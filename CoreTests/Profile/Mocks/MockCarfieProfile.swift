//
//  MockCarfieProfile.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/11/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

extension CarfieProfile {
    init(id: Int, firstName: String, lastName: String, email: String, mobile: String, service: CarfieService?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobile = mobile
        self.service = service
        
        self.avatar = nil
        self.picture = nil
        self.deviceToken = nil
        self.accessToken = nil
        self.currency = nil
        self.walletBalance = nil
        self.sos = nil
        self.appContact = nil
        self.measurement = nil
        self.card = nil
        self.cash = nil
        self.stripeSecretKey = nil
        self.stripePublishableKey = nil
    }
}
