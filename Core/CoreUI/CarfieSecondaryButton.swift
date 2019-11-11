//
//  CarfieSecondaryButton.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// A small button that looks similar to a default iOS UIButton. This class mostly exists to allow
/// more specific UIAppearance selection that won't affect all UIButtons.
class CarfieSecondaryButton: UIButton {
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
}
