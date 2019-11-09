//
//  CarfieAppearance.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/4/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation
import Stripe

/// Configures the app target's UIAppearance settings.
struct CarfieAppearance {
    static func configureTheme(_ theme: AppTheme) {
        CarfieButton.appearance().backgroundColor = theme.primaryButtonColor
        STPPaymentCardTextField.appearance().tintColor = theme.tintColor
    }
}
