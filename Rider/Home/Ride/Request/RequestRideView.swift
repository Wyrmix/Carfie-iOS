//
//  RequestRideView.swift
//  Rider
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class RequestRideView: UIView {
    
    private let proceedButton: CarfieButton = {
        let button = CarfieButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Proceed", for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setup() {
        backgroundColor = .white
    }
}
