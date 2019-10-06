//
//  Contacts.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/2/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct CarfieContact {
    static let supportPhoneNumber = "18003112794"

    static let supportEmail = "support@carfie.com"
    static let supportEmailSubject = "Carfie support"

    struct Error {
        static let invalidPhoneNumber = "The call cannot be started."
        static let genericEmailError = "Something went wrong with your email."
    }
}
