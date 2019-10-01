//
//  WalletHeader.swift
//  Provider
//
//  Created by CSS on 12/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class WalletHeader: UIView {
    
    @IBOutlet private weak var labelTransactionId : UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet private weak var labelAmount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        self.setDesign()
    }
}

extension WalletHeader {
    private func initialLoads() {
        self.labelTransactionId.text = Constants.string.transactionId.localize().uppercased()
        self.labelDate.text = Constants.string.date.localize().uppercased()
        self.labelAmount.text = Constants.string.amount.localize().uppercased()
    }
    
    private func setDesign() {
        Common.setFont(to: labelTransactionId, isTitle: true)
        Common.setFont(to: labelAmount, isTitle: true)
        Common.setFont(to: labelDate, isTitle: true)
    }
}
