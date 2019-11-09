//
//  DocumentView.swift
//  Carfie
//
//  Created by Christopher.Olsen on 11/5/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DocumentView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let uploadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        
        uploadButton.backgroundColor = .white
        uploadButton.layer.cornerRadius = 12
        
        addSubview(titleLabel)
        addSubview(uploadButton)
        
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.16
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            uploadButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            uploadButton.widthAnchor.constraint(equalTo: widthAnchor),
            uploadButton.heightAnchor.constraint(equalTo: uploadButton.widthAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
