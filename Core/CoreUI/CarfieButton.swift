//
//  CarfieButton.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/21/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// Primary button theme for Carfie apps. Creates a button with fully rounded corners and
/// a semi-bold title.
class CarfieButton: UIButton {
    
    private let theme: AppTheme
    
    init(theme: AppTheme) {
        self.theme = theme
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setup() {
        tintColor = .white
        clipsToBounds = true
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        switch theme {
        case .driver:
            backgroundColor = .carfieOrange
        case .rider:
            backgroundColor = .carfieFuscia
        }
        
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
