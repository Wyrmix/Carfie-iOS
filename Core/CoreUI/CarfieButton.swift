//
//  CarfieButton.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/21/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// CarfieButton's use this type to determine various styling attributes such as
/// font size, color, etc.
enum ButtonStyle {
    
    /// A primary button uses the primary app color and a semibold font size of 20.
    case primary
    
    /// A small primary button uses the primary app color and a semibold font size of 13.
    case smallPrimary
    
    var font: UIFont {
        switch self {
        case .primary:
            return .systemFont(ofSize: 20, weight: .semibold)
        case .smallPrimary:
            return .systemFont(ofSize: 13, weight: .semibold)
        }
    }
}

/// Primary button theme for Carfie apps. Creates a button with fully rounded corners and
/// a semi-bold title.
class CarfieButton: UIButton {
    
    private let theme: AppTheme?
    private let style: ButtonStyle
    
    init(theme: AppTheme?, style: ButtonStyle = .primary) {
        self.theme = theme
        self.style = style
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setup() {
        tintColor = .white
        clipsToBounds = true
        setTitleColor(.white, for: .normal)
        titleLabel?.font = style.font
        
        applyTheme(theme)
        
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.16
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }
    
    /// Apply a new app theme to the button. Useful for situations where the theme cannot be
    /// injected during initialization.
    /// - Parameter theme: the app theme (Driver or Rider)
    func applyNewTheme(_ theme: AppTheme) {
        applyTheme(theme)
    }
    
    private func applyTheme(_ theme: AppTheme?) {
        switch theme {
        case .driver:
            backgroundColor = .carfieOrange
        case .rider:
            backgroundColor = .carfieFuscia
        default:
            backgroundColor = .carfieTeal
        }
    }
}
