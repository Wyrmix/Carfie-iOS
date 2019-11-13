//
//  CarfieAppearance.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/4/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation
import Stripe
import UIKit

/// Configures the app target's UIAppearance settings.
struct CarfieAppearance {
    static func configureTheme(_ theme: AppTheme) {
        CarfieButton.appearance().backgroundColor = theme.primaryButtonColor
        CarfieSecondaryButton.appearance().setTitleColor(theme.tintColor, for: .normal)
        
        STPPaymentCardTextField.appearance().tintColor = theme.tintColor
    }
}
