//
//  AppVersionView.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class AppVersionView: UIView {
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .carfieSmallBody
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        
        addSubview(versionLabel)
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "App Version: \(appVersion)"
        } else {
            versionLabel.text = .Empty
        }
        
        NSLayoutConstraint.activate([
            versionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            versionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            versionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
