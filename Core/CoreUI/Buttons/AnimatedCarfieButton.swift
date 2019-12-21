//
//  AnimatedCarfieButton.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// A Carfie styled button that contains a UIActivityIndicatorView for representing long running
/// asynchonous actions.
class AnimatedCarfieButton: CarfieButton {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = false
        indicator.isHidden = true
        return indicator
    }()
    
    override init(style: ButtonStyle = .primary) {
        super.init(style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.heightAnchor.constraint(equalTo: heightAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.25) {
            self.titleLabel?.alpha = 0.0
            self.activityIndicator.isHidden = false
        }
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        
        UIView.animate(withDuration: 0.25) {
            self.titleLabel?.alpha = 1.0
            self.activityIndicator.isHidden = true
        }
    }
}
