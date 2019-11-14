//
//  PaymentTableViewCellViewModel.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/13/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct PaymentTableViewCellViewModel {
    let image: UIImage?
    let text: String
    
    init(lastFourCardDigits: String) {
        self.image = UIImage(named: "CreditCard")
        self.text = "XXXX-XXXX-XXXX-\(lastFourCardDigits)"
    }
}
