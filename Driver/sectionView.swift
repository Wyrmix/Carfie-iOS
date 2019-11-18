//
//  sectionView.swift
//  User
//
//  Created by CSS on 13/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class sectionView: UIView {

    @IBOutlet var labelTime: UILabel! {
        didSet {
            labelTime.font = .carfieHeading
            labelTime.text = "Time"
        }
    }
    
    @IBOutlet var labelAmount: UILabel! {
        didSet {
            labelAmount.font = .carfieHeading
            labelAmount.text = "Amount"
        }
    }
    
    @IBOutlet var labelDistance: UILabel! {
        didSet {
            labelDistance.font = .carfieHeading
            labelDistance.text = "Distance"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = AppTheme.driver.primaryColor
    }
}
