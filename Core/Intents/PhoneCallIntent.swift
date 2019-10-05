//
//  PhoneCallIntent.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/2/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// Intent to trigger calling a phone call URL scheme.
final class PhoneCallIntent {

    private let url: URL

    init?(phoneNumber: String) {
        let sanitizedPhoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
                                              .replacingOccurrences(of: " ", with: "")
                                              .replacingOccurrences(of: "(", with: "")
                                              .replacingOccurrences(of: ")", with: "")

        guard let url = URL(string: "tel://\(sanitizedPhoneNumber)") else {
            assertionFailure("Invalid phone number url.")
            UIApplication.shared.keyWindow?.make(toast: CarfieContact.Error.invalidPhoneNumber)
            return nil
        }

        self.url = url
    }

    func execute() {
        UIApplication.shared.open(url)
    }
}

extension PhoneCallIntent {
    static func callCarfieSupport() -> PhoneCallIntent? {
        return PhoneCallIntent(phoneNumber: CarfieContact.supportPhoneNumber)
    }
}
